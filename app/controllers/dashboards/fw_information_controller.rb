class Dashboards::FwInformationController < InternalController
  # layout "application"

  def index
    # Filters Data
    @countries = specific_countries
    @states = Rails.cache.fetch("state_names", expires_in: 1.day) { State.order(:name).pluck(:id, :name) }
    @job_type = JobType.order(:name).pluck(:id, :name) # Sectors
    # @organizations = Organization.distinct.pluck(:name)
    @foregin_worker_type = Transaction.registration_types.keys # Foreign Worker Type
    @organizations = Organization.order(:name).pluck(:name)

    respond_to do |format|
      format.html
      format.js { render layout: false } # Add this line to you respond_to block
    end
  end

  def registration_counts
    filters = params[:data]
    start_time, end_time = date_range_values(filters)
    filtered_data = if filters.present?
                      Transaction.where(created_at: start_time..end_time)
                      # filtered_transactions(params[:data]).joins(doctor: :state).order("states.name")
                    else
                      Transaction.where(created_at: start_time..end_time)
                    end

    select_clause = <<~SQL
      COUNT(1) as transactions_count,
      COUNT(CASE WHEN medical_examination_date BETWEEN '#{start_time}' AND '#{end_time}' THEN transactions.id END) AS passed_examination_count,
      COUNT(DISTINCT CASE WHEN certification_date BETWEEN '#{start_time}' AND '#{end_time}' THEN transactions.id END) AS certification_count,
      COUNT(DISTINCT CASE WHEN final_result IS NULL THEN transactions.id END) AS final_result_count
    SQL

    resp = filtered_data.select(select_clause)[0]
    @transactions_count = resp.transactions_count
    @passed_examination_count = resp.passed_examination_count
    @certification_count = resp.certification_count
    @final_result = resp.final_result_count

    @side_bar_medical_appeals = filtered_data.joins(:medical_appeals).count
    @block_fw = filtered_data.joins(:myimms_transaction).group('myimms_transactions.status').count
    @block_fw.transform_keys! { |key| MyimmsTransaction::RESPONSE_STATUS[key] || key }

    # FW counts
    fetch_fw_counts(filtered_data, start_time, end_time)
    other_fw_counts(filtered_data, start_time, end_time)

    render layout: false
  end

  def registration_by_states
    filtered_data = if params[:data].present?
                      filtered_transactions(params[:data])
                    else
                      state_ids = Transaction.joins(doctor: :state).where("extract(year from transactions.created_at) = ?", Date.today.year).pluck('states.id')
                      hash = {}
                      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
                      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
                      converted_hash = {}
                      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
                      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }
                    end
    filtered_data

    render layout: false
  end

  def registration_by_sectors
    filtered_data = if params[:data].present?
                      filtered_transactions(params[:data])
                    else
                      Transaction.where(created_at: start_of_curr_year..end_of_curr_year)
                    end

    job_types_count = filtered_data.joins(:fw_job_type).
      group('job_types.name').
      pluck('job_types.name', 'COUNT(1)')
    @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]
    render layout: false
  end

  def registration_by_countries
    filtered_data = if params[:data].present?
                      filtered_transactions(params[:data])
                    else
                      allowed_countries = ['BANGLADESH', 'NEPAL', 'INDONESIA', 'MYANMAR', 'INDIA',
                      'PAKISTAN', 'PHILIPPINES', 'VIETNAM', 'SRI LANKA', 'THAILAND', 'CAMBODIA', 'LAOS',
                      'UZBEKISTAN', 'TURKMENISTAN', 'KAZAKHSTAN']

                      @fw_Reg_by_countries = Transaction
                      .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                      .group('countries.name', 'countries.code')
                      .where("extract(year from transactions.created_at) = ?", Date.today.year)
                      .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                      .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }
                      .select { |entry| allowed_countries.include?(entry[0].upcase) }

                      others_count = Transaction.count - @fw_Reg_by_countries.sum { |entry| entry[2] }
                      others_entry = ['Others', 'OTH', others_count]
                      @fw_Reg_by_countries << others_entry
                      @fw_Reg_by_countries.sort_by! { |entry| entry[0] }
                    end

    filtered_data

    render layout: false
  end

  def registration_trends
    start_time, end_time = date_range_values(params[:data])

    @transaction_line_chart = if params[:data].present?
                                filtered_transactions(params[:data]).transaction_data_between(start_time: start_time, end_time: end_time)
                              else
                                start_time = start_of_curr_year - 4.years
                                end_time = end_of_curr_year
                                Transaction.transaction_data_last_5_years rescue {}
                              end

    if @transaction_line_chart.blank?
      current_year = start_of_curr_year.year
      last_five_years = (current_year - 4..current_year)

      @transaction_line_chart = last_five_years.each_with_object({}) do |year, chart_data|
        chart_data[year] = [0] * 12
      end
    end
    
    if @transaction_line_chart.present? && @transaction_line_chart.values.any? { |data| data.sum > 0 }
    @sums_by_year = @transaction_line_chart.transform_values { |data| data.sum }
  else
    date_range = params[:data][:date_range]
    start_date_str, end_date_str = date_range.split(" - ")
    selected_year = start_date_str.split("/").last.to_i

    @transaction_line_chart = { selected_year => Array.new(12, 0) }
    @sums_by_year = @transaction_line_chart.transform_values { |data| data.sum }
  end

    render layout: false
  end

  def start_of_curr_year
    @start_of_curr_year ||= (Time.now - 1.month).beginning_of_year
  end

  def end_of_curr_year
    @end_of_curr_year ||= (Time.now - 1.month).end_of_year
  end

  def filtered_transactions(filters)
    transactions = Transaction
    transactions = apply_country_filter(filters, transactions)
    transactions = apply_date_range_filer(filters, transactions)

    if filters[:sectors].present?
      start_time, end_time = date_range_values(filters)
      transactions = transactions.joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(job_types: { id: filters[:sectors] })

     # sector data to display in state
     state_ids = transactions.joins(doctor: :state).pluck('states.id')
     hash = {}
     state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
     state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
     converted_hash = {}
     state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
     @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

     # sector data to display in country
     @fw_Reg_by_countries = transactions
                              .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                              .group('countries.name', 'countries.code')
                              .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                              .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }
    end

    if filters[:states].present?
      start_time, end_time = date_range_values(filters)
      state_ids = Transaction.joins(doctor: :state).where(created_at: start_time..end_time).where(states: { id: filters[:states] }).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

       # state data to display in sector
       transactions = Transaction.joins(doctor: :state).joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(states: { id: filters[:states] })
       job_types_count = transactions.
         group('job_types.name').
         pluck('job_types.name', 'COUNT(1)')
       @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]

      # state data to display in country
      @fw_Reg_by_countries = Transaction
                              .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                              .joins(doctor: :state)
                              .where(created_at: start_time..end_time)
                              .where(states: { id: filters[:states] })
                              .group('countries.name', 'countries.code')
                              .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                              .map { |entry| entry.country_info.split(',') + [entry.count.to_i] } 

    else
      start_time, end_time = date_range_values(filters)
      state_ids = Transaction.joins(doctor: :state).where(created_at: start_time..end_time).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

    end

    if filters[:age].present?
      age_params = filters[:age]

      conditions = age_params.map do |age_param|
        if age_param.include?('-')
          age_start, age_end = age_param.split('-').map(&:to_i)
          birth_date_start = Date.today - age_end.years
          birth_date_end = Date.today - age_start.years

          "(fw_date_of_birth BETWEEN '#{birth_date_end}' AND '#{birth_date_start}')"
        else
          age_value = age_param.to_i
          birth_date_start = Date.today - age_value.years

          "fw_date_of_birth <= '#{birth_date_start}'"
        end
      end
      conditions_query = conditions.join(' OR ')

      # age data to display in sectors
      transactions = Transaction.joins(doctor: :state).joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(conditions_query)
      job_types_count = transactions.
        group('job_types.name').
        pluck('job_types.name', 'COUNT(1)')
      @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]

      # age data to display in states
      state_ids = Transaction.where(created_at: start_time..end_time).where(conditions_query).joins(doctor: :state).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

      # age data to display in countries
      @fw_Reg_by_countries = Transaction.where(created_at: start_time..end_time).where(conditions_query)
                                        .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                        .group('countries.name', 'countries.code')
                                        .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                        .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }
    end

    if filters[:gender].present?


      # gender data to display in sectors
      transactions = Transaction.joins(doctor: :state).joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(fw_gender: filters[:gender])
      job_types_count = transactions.
        group('job_types.name').
        pluck('job_types.name', 'COUNT(1)')
      @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]

      # gender data to display in states
      state_ids = Transaction.where(created_at: start_time..end_time).where(fw_gender: filters[:gender]).joins(doctor: :state).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

      # gender data to display in countries
      @fw_Reg_by_countries = Transaction.where(created_at: start_time..end_time).where(fw_gender: filters[:gender])
                                        .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                        .group('countries.name', 'countries.code')
                                        .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                        .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

    end

    if filters[:fw_types].present?
      registration_type_values = {
        "new" => 0,
        "renewal" => 1
      }

      # registration data to display in sectors
      transactions = Transaction.joins(doctor: :state).joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      job_types_count = transactions.
        group('job_types.name').
        pluck('job_types.name', 'COUNT(1)')
      @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]

      # registration data to display in states
      state_ids = Transaction.where(created_at: start_time..end_time).where(registration_type: registration_type_values.values_at(*filters[:fw_types])).joins(doctor: :state).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

      # registration data to display in countries
      @fw_Reg_by_countries = Transaction.where(created_at: start_time..end_time).where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
                                        .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                        .group('countries.name', 'countries.code')
                                        .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                        .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

    end

    if filters[:registration_types].present?
      organization_ids = Organization.where(name: filters[:registration_types]).pluck(:id)

      # registration_types data to display in sectors
      transactions = Transaction.joins(doctor: :state).joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(organization_id: organization_ids)
      job_types_count = transactions.
        group('job_types.name').
        pluck('job_types.name', 'COUNT(1)')
      @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]

      # registration_types data to display in states
      state_ids = Transaction.where(created_at: start_time..end_time).where(organization_id: organization_ids).joins(doctor: :state).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

      # registration_types data to display in countries
      @fw_Reg_by_countries = Transaction.where(created_at: start_time..end_time).where(organization_id: organization_ids)
                                        .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                        .group('countries.name', 'countries.code')
                                        .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                        .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

    end

    transactions
  end

  def apply_country_filter(filters, transactions)
    if filters[:countries].present? && filters[:other_countries].to_s == 'false'
      start_time, end_time = date_range_values(params[:data])
      countries = Transaction.joins("JOIN countries ON countries.id = transactions.fw_country_id").where(
        "countries.id IN (?)",
        (filters[:countries].present? ? filters[:countries] : [])
      ).where(created_at: start_time..end_time)
                             .group('countries.name', 'countries.code')
                             .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                             .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

        @fw_Reg_by_countries = countries

        # country data to display in sectors
        transactions = Transaction.joins("JOIN countries ON countries.id = transactions.fw_country_id")
        .joins("JOIN job_types ON job_types.id = transactions.fw_job_type_id")
        .where(created_at: start_time..end_time)
        .where(countries: { id: filters[:countries] })
        job_types_count = transactions.group('job_types.name').pluck('job_types.name', 'COUNT(1)')
        @pi_chart_data = [['Task', 'Hours per Day'], *job_types_count]

        # country data to display in states
        state_ids = Transaction.where(fw_country_id: filters[:countries]).where(created_at: start_time..end_time).joins(doctor: :state).pluck('states.id')
        hash = {}
        state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
        state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
        converted_hash = {}
        state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
        @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

    elsif filters[:other_countries].to_s == 'true'
      country_ids = specific_countries.map { |i| i[0] }
      other_countries = Transaction.joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                   .where.not(countries: { id: country_ids })
                                   .group('countries.name', 'countries.code')
                                   .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                   .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }
      @fw_Reg_by_countries = other_countries
    else
      start_time, end_time = date_range_values(filters)
      @fw_Reg_by_countries = Transaction
                               .joins("JOIN countries ON countries.id = transactions.fw_country_id").where(created_at: start_time..end_time)
                               .group('countries.name', 'countries.code')
                               .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                               .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }
    end
    transactions
  end

  def apply_date_range_filer(filters, transactions)
    start_time, end_time = date_range_values(filters)
    transactions = transactions.where(created_at: start_time..end_time)
    transactions
  end

  def date_range_values(filters)
    if filters.present? && filters[:date_range].present?
      date_range = filters[:date_range].split(' - ').map(&:to_time)
      if (date_range.count == 2)
        start_time = (date_range[0] < date_range[1] ? date_range[0] : date_range[1]).beginning_of_day
        end_time = (date_range[0] > date_range[1] ? date_range[0] : date_range[1]).end_of_day
      elsif (date_range.count == 1)
        start_time = date_range[0].beginning_of_day
        end_time = date_range[0].end_of_day
      else
        start_time = start_of_curr_year
        end_time = end_of_curr_year
      end
    else
      start_time = start_of_curr_year
      end_time = end_of_curr_year
    end
    [start_time, end_time]
  end

  def fetch_fw_counts(transactions, start_time, end_time)
    select_clause = <<~SQL
      COUNT(DISTINCT transactions.id) AS fw_insured,
      COUNT(DISTINCT CASE WHEN medical_examination_date BETWEEN '#{start_time}' AND '#{end_time}' THEN transactions.id END) AS fw_medicalexamiation,
      COUNT(DISTINCT CASE WHEN certification_date BETWEEN '#{start_time}' AND '#{end_time}' THEN transactions.id END) AS fw_certification,
      COUNT(DISTINCT CASE WHEN final_result_date BETWEEN '#{start_time}' AND '#{end_time}' THEN transactions.id END) AS fw_finalresult,
      COUNT(DISTINCT CASE WHEN final_result_date BETWEEN '#{start_time}' AND '#{end_time}' THEN myimms_transactions.id END) AS fw_resulttransmitted,
      COUNT(DISTINCT CASE WHEN medical_appeals.created_at BETWEEN '#{start_time}' AND '#{end_time}' THEN medical_appeals.id END) AS fw_appeal
    SQL
    fw_counts = transactions.left_joins(:medical_appeals, :myimms_transaction).
      select(select_clause)
    result = fw_counts[0]
    @fw_insured = result.fw_insured
    @fw_medicalexamiation = result.fw_medicalexamiation
    @fw_certification = result.fw_certification
    @fw_finalresult = result.fw_finalresult
    @fw_resulttransmitted = result.fw_resulttransmitted
    @fw_blocked = result.fw_resulttransmitted
    @fw_appeal = result.fw_appeal
  end

  def other_fw_counts(transactions, start_time, end_time)
    select_clause = <<~SQL
      COUNT(DISTINCT CASE WHEN xray_reviews.transaction_id IS NOT NULL THEN transactions.id END) AS xqcc_poolreviewed_count,
      COUNT(DISTINCT CASE WHEN xray_reviews.transaction_id IS NOT NULL THEN transactions.id END) AS xqcc_poolreview_count,
      COUNT(DISTINCT CASE WHEN xqcc_pools.transaction_id IS NOT NULL THEN transactions.id END) AS xqcc_poolreceive_count,
      COUNT(DISTINCT CASE WHEN pcr_pools.transaction_id IS NOT NULL THEN transactions.id END) AS pcr_poolreceived_count,
      COUNT(DISTINCT CASE WHEN pcr_reviews.transaction_id IS NOT NULL THEN transactions.id END) AS pcr_poolreviewed_count,
      COUNT(DISTINCT CASE WHEN xray_pending_reviews.transaction_id IS NOT NULL THEN transactions.id END) AS x_ray_pending_review_count,
      COUNT(DISTINCT CASE WHEN xray_pending_decisions.transaction_id IS NOT NULL THEN transactions.id END) AS x_ray_pending_decision_count,
      COUNT(DISTINCT CASE WHEN medical_reviews.created_at IS NOT NULL
                              AND medical_reviews.medical_mle1_decision_at IS NOT NULL
                              AND medical_reviews.qa_decision_at IS NOT NULL
                              AND medical_reviews.is_qa = TRUE
                            THEN transactions.id END) AS medical_review_count
    SQL
    fw_counts = transactions.left_joins(:xray_reviews, :xqcc_pools, :pcr_pools, :pcr_reviews,
                                        :xray_pending_reviews, :xray_pending_decisions, :medical_reviews).
      where.not(certification_date: nil).
      select(select_clause)
    result = fw_counts[0]
    @xqcc_poolreviewed = result.xqcc_poolreviewed_count
    @xqcc_poolreview = result.xqcc_poolreview_count
    @xqcc_poolreceive = result.xqcc_poolreceive_count
    @pcr_poolreceived = result.pcr_poolreceived_count
    @pcr_poolreviewed = result.pcr_poolreviewed_count
    @x_ray_pending_review = result.x_ray_pending_review_count
    @x_ray_pending_decision = result.x_ray_pending_decision_count
    @medical_review = result.medical_review_count
    @fw_pendingview = @xqcc_poolreceive + @xqcc_poolreview + @pcr_poolreceived + @pcr_poolreviewed + @x_ray_pending_review + @x_ray_pending_decision + @medical_review
  end

  def excel_generate

    @xqcc_pool_received_count = fetch_counts(Transaction.joins(:xqcc_pools), 'xqcc_pools.created_at')
    @xqcc_pool_reviewed_count = fetch_counts(Transaction.joins(:xray_reviews), 'xray_reviews.transmitted_at')
    @pcr_pool_received_count = fetch_counts(Transaction.joins(:pcr_pools), 'pcr_pools.created_at')
    @pcr_pool_reviewed_count = fetch_counts(Transaction.joins(:pcr_reviews), 'pcr_reviews.created_at')
    @xray_pending_review_received_count = fetch_counts(Transaction.joins(:xray_pending_reviews), 'xray_pending_reviews.created_at')
    @xray_pending_review_reviewed_count = fetch_counts(Transaction.joins(:xray_pending_reviews), 'xray_pending_reviews.transmitted_at')
    @xray_pending_decision_received_count = fetch_counts(Transaction.joins(:xray_pending_decisions), 'xray_pending_decisions.created_at')
    @xray_pending_decision_reviewed_count = fetch_counts(Transaction.joins(:xray_pending_decisions), 'xray_pending_decisions.transmitted_at')

    respond_to do |format|
      format.xlsx do
        package = Axlsx::Package.new

        add_sheet_by_country(package)
        add_sheet_by_state(package)
        add_sheet_by_sector(package)
        add_sheet_by_gender(package)
        add_sheet_by_registration_at(package)
        add_sheet_by_fw_type(package)
        add_sheet_by_line_chart(package)

        # Save the Excel file
        send_data package.to_stream.read, filename: 'fw_information.xlsx'
      end
    end
  end

  def fetch_counts(query, date_column)
    query.order('transactions.created_at DESC')
         .limit(50)
         .group("#{date_column}, transactions.certification_date, transactions.created_at")
         .count.values
  end

  def add_sheet_by_country(package)
    @countries = Country.pluck(:name).compact.reject(&:empty?).uniq

    unless @countries.empty?
      country_ids = Country.where(name: @countries).pluck(:id)
      country_data = Transaction.where(fw_country_id: country_ids)
                                .group(:fw_country_id)
                                .select(
                                  'fw_country_id',
                                  'COUNT(*) AS total_fw_registration_count',
                                  'COUNT(medical_examination_date) AS examination_count',
                                  'COUNT(certification_date) AS certification_count'
                                )
      result_hash = {}
      country_data.each do |data|
        result_hash[data.fw_country_id] = {
          total_fw_registration_count: data.total_fw_registration_count.to_i,
          examination_count: data.examination_count.to_i,
          certification_count: data.certification_count.to_i
        }
      end
      package.workbook.add_worksheet(name: 'FW Reg. by Country') do |sheet|
        # Header row
        sheet.add_row [
                        'Country',
                        'Total FW Registration',
                        'Examination Count',
                        'Certification Count',
                        'XQCC Pool Received',
                        'XQCC Pool Reviewed',
                        'PCR Pool Received',
                        'PCR Pool Reviewed',
                        'Xray Pending Review Received',
                        'Xray Pending Review Reviewed',
                        'Xray Pending Decision Received',
                        'Xray Pending Decision Reviewed'
                      ], b: true

        # Add data for each country
        result_hash.each do |fw_country_id, counts|
          country_name = Country.find(fw_country_id).name
          xqcc_pool_received_count = @xqcc_pool_received_count.sum
          xqcc_pool_reviewed_count = @xqcc_pool_reviewed_count.sum
          pcr_pool_received_count = @pcr_pool_received_count.sum
          pcr_pool_received_count = @pcr_pool_reviewed_count.sum
          xray_pending_review_received_count = @xray_pending_review_received_count.sum
          xray_pending_review_reviewed_count = @xray_pending_review_reviewed_count.sum
          xray_pending_decision_received_count = @xray_pending_decision_received_count.sum
          xray_pending_decision_reviewed_count = @xray_pending_decision_reviewed_count.sum

          sheet.add_row [
                          country_name,
                          counts[:total_fw_registration_count],
                          counts[:examination_count],
                          counts[:certification_count],
                          xqcc_pool_received_count,
                          xqcc_pool_reviewed_count,
                          pcr_pool_received_count,
                          pcr_pool_received_count,
                          xray_pending_review_received_count,
                          xray_pending_review_reviewed_count,
                          xray_pending_decision_received_count,
                          xray_pending_decision_reviewed_count
                        ]
        end
      end
    end
  end

  def add_sheet_by_state(package)
    @states = State.pluck(:name).compact.uniq
    states_with_ids = State.where(name: @states).pluck(:name, :id).to_h
    doctor_ids = Doctor.where(state_id: states_with_ids.values).pluck(:id)

    unless @states.empty?
      state_data = Transaction.joins(doctor: :state)
                              .where(states: { id: states_with_ids.values })
                              .group('states.name')
                              .select(
                                'states.name AS state',
                                'COUNT(DISTINCT transactions.id) AS total_fw_registration_count',
                                'SUM(CASE WHEN transactions.medical_examination_date IS NOT NULL THEN 1 ELSE 0 END) AS examination_count',
                                'SUM(CASE WHEN transactions.certification_date IS NOT NULL THEN 1 ELSE 0 END) AS certification_count'
                              )
      package.workbook.add_worksheet(name: 'FW Reg. by State') do |sheet|

        # Header row
        sheet.add_row [
                        'State',
                        'Total FW Registration',
                        'Examination Count',
                        'Certification Count',
                        'XQCC Pool Received',
                        'XQCC Pool Reviewed',
                        'PCR Pool Received',
                        'PCR Pool Reviewed',
                        'Xray Pending Review Received',
                        'Xray Pending Review Reviewed',
                        'Xray Pending Decision Received',
                        'Xray Pending Decision Reviewed'
                      ], b: true

        # Add data for each state
        state_data.each do |data|
          sheet.add_row [
                          data.state,
                          data.total_fw_registration_count.to_i,
                          data.examination_count.to_i,
                          data.certification_count.to_i,
                          @xqcc_pool_received_count,
                          @xqcc_pool_reviewed_count,
                          @pcr_pool_received_count,
                          @pcr_pool_reviewed_count,
                          @xray_pending_review_received_count,
                          @xray_pending_review_reviewed_count,
                          @xray_pending_decision_received_count,
                          @xray_pending_decision_reviewed_count
                        ]
        end
      end
    end
  end

  def add_sheet_by_gender(package)
    genders = ['M', 'F']
    gender_data = Transaction.where(fw_gender: genders)
                             .group(:fw_gender)
                             .select(
                               'fw_gender AS gender',
                               'COUNT(*) AS total_fw_registration_count',
                               'COUNT(medical_examination_date) AS examination_count',
                               'COUNT(certification_date) AS certification_count'
                             )

    package.workbook.add_worksheet(name: 'FW Reg. by Gender') do |sheet|

      # Header row
      sheet.add_row [
                      'Gender',
                      'Total FW Registration',
                      'Examination Count',
                      'Certification Count',
                      'XQCC Pool Received',
                      'XQCC Pool Reviewed',
                      'PCR Pool Received',
                      'PCR Pool Reviewed',
                      'Xray Pending Review Received',
                      'Xray Pending Review Reviewed',
                      'Xray Pending Decision Received',
                      'Xray Pending Decision Reviewed'
                    ], b: true

      xqcc_pool_received_count = @xqcc_pool_received_count.sum
      xqcc_pool_reviewed_count = @xqcc_pool_reviewed_count.sum
      pcr_pool_received_count = @pcr_pool_received_count.sum
      pcr_pool_received_count = @pcr_pool_reviewed_count.sum
      xray_pending_review_received_count = @xray_pending_review_received_count.sum
      xray_pending_review_reviewed_count = @xray_pending_review_reviewed_count.sum
      xray_pending_decision_received_count = @xray_pending_decision_received_count.sum
      xray_pending_decision_reviewed_count = @xray_pending_decision_reviewed_count.sum

      gender_data.each do |data|
        sheet.add_row [
                        data.gender,
                        data.total_fw_registration_count.to_i,
                        data.examination_count.to_i,
                        data.certification_count.to_i,
                        xqcc_pool_received_count,
                        xqcc_pool_reviewed_count,
                        pcr_pool_received_count,
                        pcr_pool_received_count,
                        xray_pending_review_received_count,
                        xray_pending_review_reviewed_count,
                        xray_pending_decision_received_count,
                        xray_pending_decision_reviewed_count
                      ]
      end
    end
  end

  def add_sheet_by_sector(package)
    @job_type = JobType.pluck(:name).compact.uniq

    unless @job_type.empty?
      job_type_with_ids = JobType.where(name: @job_type).pluck(:id)
      job_type_data = Transaction.where(fw_job_type_id: job_type_with_ids)
                                 .group(:fw_job_type_id)
                                 .select(
                                   'fw_job_type_id',
                                   'COUNT(*) AS total_fw_registration_count',
                                   'COUNT(medical_examination_date) AS examination_count',
                                   'COUNT(certification_date) AS certification_count'
                                 )
      result_hash = {}
      job_type_data.each do |data|
        result_hash[data.fw_job_type_id] = {
          total_fw_registration_count: data.total_fw_registration_count.to_i,
          examination_count: data.examination_count.to_i,
          certification_count: data.certification_count.to_i
        }
      end
      package.workbook.add_worksheet(name: 'FW Reg. by Sector') do |sheet|
        # Header row
        sheet.add_row [
                        'Sector',
                        'Total FW Registration',
                        'Examination Count',
                        'Certification Count',
                        'XQCC Pool Received',
                        'XQCC Pool Reviewed',
                        'PCR Pool Received',
                        'PCR Pool Reviewed',
                        'Xray Pending Review Received',
                        'Xray Pending Review Reviewed',
                        'Xray Pending Decision Received',
                        'Xray Pending Decision Reviewed'
                      ], b: true

        result_hash.each do |fw_job_type_id, counts|
          sector_name = JobType.find(fw_job_type_id).name
          xqcc_pool_received_count = @xqcc_pool_received_count.sum
          xqcc_pool_reviewed_count = @xqcc_pool_reviewed_count.sum
          pcr_pool_received_count = @pcr_pool_received_count.sum
          pcr_pool_received_count = @pcr_pool_reviewed_count.sum
          xray_pending_review_received_count = @xray_pending_review_received_count.sum
          xray_pending_review_reviewed_count = @xray_pending_review_reviewed_count.sum
          xray_pending_decision_received_count = @xray_pending_decision_received_count.sum
          xray_pending_decision_reviewed_count = @xray_pending_decision_reviewed_count.sum

          sheet.add_row [
                          sector_name,
                          counts[:total_fw_registration_count],
                          counts[:examination_count],
                          counts[:certification_count],
                          xqcc_pool_received_count,
                          xqcc_pool_reviewed_count,
                          pcr_pool_received_count,
                          pcr_pool_received_count,
                          xray_pending_review_received_count,
                          xray_pending_review_reviewed_count,
                          xray_pending_decision_received_count,
                          xray_pending_decision_reviewed_count
                        ]
        end
      end
    end
  end

  def add_sheet_by_registration_at(package)
    @organizations = Organization.pluck(:name).uniq

    unless @organizations.empty?
      organization_with_ids = Organization.where(name: @organizations).pluck(:id)
      registration_at_data = Transaction.where(organization_id: organization_with_ids)
                                        .group(:organization_id)
                                        .select(
                                          'organization_id',
                                          'COUNT(*) AS total_fw_registration_count',
                                          'COUNT(medical_examination_date) AS examination_count',
                                          'COUNT(certification_date) AS certification_count'
                                        )
      result_hash = {}
      registration_at_data.each do |data|
        result_hash[data.organization_id] = {
          total_fw_registration_count: data.total_fw_registration_count.to_i,
          examination_count: data.examination_count.to_i,
          certification_count: data.certification_count.to_i
        }
      end
      package.workbook.add_worksheet(name: 'FW Reg. by FW Type') do |sheet|
        # Header row
        sheet.add_row [
                        'FW registration by Registration at',
                        'Total FW Registration',
                        'Examination Count',
                        'Certification Count',
                        'XQCC Pool Received',
                        'XQCC Pool Reviewed',
                        'PCR Pool Received',
                        'PCR Pool Reviewed',
                        'Xray Pending Review Received',
                        'Xray Pending Review Reviewed',
                        'Xray Pending Decision Received',
                        'Xray Pending Decision Reviewed'
                      ], b: true

        result_hash.each do |organization_id, counts|
          organization_name = Organization.find(organization_id).name
          xqcc_pool_received_count = @xqcc_pool_received_count.sum
          xqcc_pool_reviewed_count = @xqcc_pool_reviewed_count.sum
          pcr_pool_received_count = @pcr_pool_received_count.sum
          pcr_pool_received_count = @pcr_pool_reviewed_count.sum
          xray_pending_review_received_count = @xray_pending_review_received_count.sum
          xray_pending_review_reviewed_count = @xray_pending_review_reviewed_count.sum
          xray_pending_decision_received_count = @xray_pending_decision_received_count.sum
          xray_pending_decision_reviewed_count = @xray_pending_decision_reviewed_count.sum

          sheet.add_row [
                          organization_name,
                          counts[:total_fw_registration_count],
                          counts[:examination_count],
                          counts[:certification_count],
                          xqcc_pool_received_count,
                          xqcc_pool_reviewed_count,
                          pcr_pool_received_count,
                          pcr_pool_received_count,
                          xray_pending_review_received_count,
                          xray_pending_review_reviewed_count,
                          xray_pending_decision_received_count,
                          xray_pending_decision_reviewed_count
                        ]
        end
      end
    end
  end

  def add_sheet_by_fw_type(package)
    registration = ['0', '1']
    fw_data = Transaction.where(registration_type: registration)
                         .group(:registration_type)
                         .select(
                           'registration_type AS registration_type',
                           'COUNT(*) AS total_fw_registration_count',
                           'COUNT(medical_examination_date) AS examination_count',
                           'COUNT(certification_date) AS certification_count'
                         )

    package.workbook.add_worksheet(name: 'FW Reg. by FW Type') do |sheet|

      # Header row
      sheet.add_row [
                      'FW registration by FW Type',
                      'Total FW Registration',
                      'Examination Count',
                      'Certification Count',
                      'XQCC Pool Received',
                      'XQCC Pool Reviewed',
                      'PCR Pool Received',
                      'PCR Pool Reviewed',
                      'Xray Pending Review Received',
                      'Xray Pending Review Reviewed',
                      'Xray Pending Decision Received',
                      'Xray Pending Decision Reviewed'
                    ], b: true

      xqcc_pool_received_count = @xqcc_pool_received_count.sum
      xqcc_pool_reviewed_count = @xqcc_pool_reviewed_count.sum
      pcr_pool_received_count = @pcr_pool_received_count.sum
      pcr_pool_received_count = @pcr_pool_reviewed_count.sum
      xray_pending_review_received_count = @xray_pending_review_received_count.sum
      xray_pending_review_reviewed_count = @xray_pending_review_reviewed_count.sum
      xray_pending_decision_received_count = @xray_pending_decision_received_count.sum
      xray_pending_decision_reviewed_count = @xray_pending_decision_reviewed_count.sum

      fw_data.each do |data|
        sheet.add_row [
                        data.registration_type,
                        data.total_fw_registration_count.to_i,
                        data.examination_count.to_i,
                        data.certification_count.to_i,
                        xqcc_pool_received_count,
                        xqcc_pool_reviewed_count,
                        pcr_pool_received_count,
                        pcr_pool_received_count,
                        xray_pending_review_received_count,
                        xray_pending_review_reviewed_count,
                        xray_pending_decision_received_count,
                        xray_pending_decision_reviewed_count
                      ]
      end
    end
  end

  def add_sheet_by_line_chart(package)

    Transaction.transaction_data_last_5_years rescue {}
    if @transaction_line_chart.blank?
      current_year = start_of_curr_year.year
      last_five_years = (current_year - 4..current_year)

      @transaction_line_chart = last_five_years.each_with_object({}) do |year, chart_data|
        chart_data[year] = [0] * 12
      end
    end

    @sums_by_year = @transaction_line_chart.transform_values { |data| data.sum }

    @headers_line_chart = @sums_by_year.keys.map(&:to_s)
    @data_line_chart = @sums_by_year.values.map(&:to_i)



    package.workbook.add_worksheet(name: 'FW Reg. by FW Type') do |sheet|

      sheet.add_row @headers_line_chart
      sheet.add_row @data_line_chart
    end

  end

  def convert_values_to_arrays(filters)
    converted_hash = {}
    filters.each do |key, value|
      converted_hash[key] = value.to_s.split(',') if value.present?
    end
    converted_hash
  end

  def apply_filter(filter_params)
    # optimise this method
    transactions = Transaction.all
    filter_params.each do |param_key, param_value|
      if param_value.present?
        case param_key
        when "DateRange"
          start_date, end_date = param_value.split(" - ").map(&:to_time)
          start_date = start_date.beginning_of_day
          end_date = end_date.end_of_day
          transactions = transactions.where(created_at: start_date..end_date)
        when "Sector"
          sector_names = JobType.pluck(:name)
          selected_sector_names = sector_names & param_value
          transactions = transactions.joins("JOIN job_types on transactions.fw_job_type_id=job_types.id").where("job_types.name" => selected_sector_names)
        when "Country"
          transactions = transactions.joins("JOIN countries on transactions.fw_country_id=countries.id").where("countries.name" => param_value)
        when "State"
          transactions = transactions.joins(doctor: :state).where(states: { id: param_value })
        when "Gender"
          transactions = transactions.where(fw_gender: param_value)
        when "age"
          age_ranges = param_value.map { |age_range| age_range.split("-").map(&:to_i) }
          birth_years = age_ranges.map do |min_age, max_age|
            birth_year_min = Date.today.year - max_age - 1
            birth_year_max = Date.today.year - min_age
            [birth_year_min, birth_year_max]
            # Find the overall minimum and maximum birth years
            overall_birth_year_min = birth_years.map(&:first).min
            overall_birth_year_max = birth_years.map(&:last).max
            transactions = transactions.where(fw_date_of_birth: Date.new(overall_birth_year_min)..Date.new(overall_birth_year_max))
          end
        when "ForeginWorker"
          transactions = transactions.where(registration_type: param_value)
        when "Registration"
          organization_names = Organization.pluck(:name)
          selected_organization_names = organization_names & param_value
          transactions = transactions.joins("JOIN organizations ON transactions.organization_id=organizations.id").where("organizations.name" => selected_organization_names)
        end
      end
    end
    transactions
  end

  def displayed_status(status)
    resp_status = {
      '1' => "SUCCESS",
      '0' => "FAILED",
      '96' => 'IMM BLOCKED',
      '97' => 'YET TO PROCEED',
      '98' => "FOREIGN WORKER BLOCKED",
      "99" => "PHYSICAL NOT DONE"
    }

    resp_status[status]
  end

  def fw_insured(transactions)
    insurance_purchase_counts = {}
    transactions.ids.each do |transaction_id|
      transaction = Transaction.find_by(id: transaction_id)
      if transaction
        # insurance_purchase_counts[transaction_id] = transaction.foreign_worker.insurance_purchases.count
      else
        insurance_purchase_counts[transaction_id] = 0
      end
    end
    insurance_purchase_counts.values.sum
  end

  def specific_countries
    specific_country_names = ['BANGLADESH', 'NEPAL', 'INDONESIA', 'MYANMAR', 'INDIA',
                              'PAKISTAN', 'PHILIPPINES', 'VIETNAM', 'SRI LANKA', 'THAILAND', 'CAMBODIA', 'LAOS',
                              'UZBEKISTAN', 'TURKMENISTAN', 'KAZAKHSTAN']

    Rails.cache.fetch("filtered_country_names", expires_in: 1.day) {
      Country.where("upper(name) in (?)", specific_country_names).distinct.pluck(:id, :name)
    }
  end
end