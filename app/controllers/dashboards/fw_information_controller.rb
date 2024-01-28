class Dashboards::FwInformationController < InternalController
  # layout "application"

  def index
    # Filters Data
    @countries = specific_countries
    @states = Rails.cache.fetch("state_names", expires_in: 1.day) { State.order(:name).pluck(:id, :name) }
    @job_type = JobType.order(:name).pluck(:id, :name) # Sectors
    # @organizations = Organization.distinct.pluck(:name)
    @foregin_worker_type = Transaction.registration_types.keys # Foreign Worker Type

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
                      @fw_Reg_by_countries = Transaction
                                               .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                               .group('countries.name', 'countries.code')
                                               .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                               .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                               .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }
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
    @sums_by_year = @transaction_line_chart.transform_values { |data| data.sum }

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
      transactions = transactions.joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(job_types: { id: filters[:sectors] })
    end

    if filters[:states].present?
      state_ids = Transaction.joins(doctor: :state).where(states: { id: filters[:states] }).pluck('states.id')
      hash = {}
      state_ids.sort.uniq.each { |h| hash[h] = state_ids.count(h) }
      state_names = State.where(id: state_ids.sort.uniq).pluck(:name, :long_code)
      converted_hash = {}
      state_names.each_with_index { |value, index| converted_hash[value] = hash.values[index] }
      @fw_reg_by_states = converted_hash.map { |key, value| key + [value] }

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

    if filters[:gender].present?
      transactions = transactions.where("UPPER(fw_gender) = (?)", values)
    end

    filters.each do |key, values|
      if values.present?
        case key
        when 'age'
        when 'registration_types'
        when 'fw_types'
        end
      end
    end

    transactions
  end

  def apply_country_filter(filters, transactions)
    if filters[:countries].present? && filters[:other_countries].to_s == 'false'
      countries = Transaction.joins("JOIN countries ON countries.id = transactions.fw_country_id").where(
        "countries.id IN (?)",
        (filters[:countries].present? ? filters[:countries] : [])
      )
                             .group('countries.name', 'countries.code')
                             .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                             .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

      @fw_Reg_by_countries = countries
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
    @total_fw_registration = {}
    @examination_count = {}
    @certification_count = {}
    @xqcc_pool_received = {}
    @xqcc_pool_reviewed = {}
    @pcr_pool_received = {}
    @pcr_pool_reviewed = {}
    @xray_pending_review_received = {}
    @xray_pending_review_reviewed = {}
    @xray_pending_decision_received = {}
    @xray_pending_decision_reviewed = {}

    @countries_excel = Country.pluck(:name).compact.uniq
    @countries_with_ids = Country.where(name: @countries_excel).pluck(:name, :id).to_h

    generate_data_for_countries

    @states_excel = State.pluck(:name).compact.uniq
    @states_with_ids = State.where(name: @states_excel).pluck(:name, :id).to_h

    generate_data_for_states

    @job_type_excel = JobType.pluck(:name).compact.uniq
    @job_type_with_ids = JobType.where(name: @job_type_excel).pluck(:name, :id).to_h
    generate_data_for_job

    @male_count = Transaction.where(fw_gender: 'M')
                             .order(created_at: :desc)
                             .limit(20)
                             .count

    @female_count = Transaction.where(fw_gender: 'F')
                               .order(created_at: :desc)
                               .limit(20)
                               .count

    @male_examination_count = Transaction.where(fw_gender: 'M')
                                         .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                         .order(created_at: :desc)
                                         .limit(20)
                                         .count

    @female_examination_count = Transaction.where(fw_gender: 'F')
                                           .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                           .order(created_at: :desc)
                                           .limit(20)
                                           .count

    @male_certification_count = Transaction.where(fw_gender: 'M')
                                           .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                           .order(created_at: :desc)
                                           .limit(20)
                                           .count

    @female_certification_count = Transaction.where(fw_gender: 'F')
                                             .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                             .order(created_at: :desc)
                                             .limit(20)
                                             .count

    @organizations_excel = Organization.pluck(:name).uniq
    @organization_with_ids = Organization.where(name: @organizations_excel).pluck(:name, :id).to_h

    generate_data_for_organization

    @new_count = Transaction.where(registration_type: 0)
                            .order(created_at: :desc)
                            .limit(20)
                            .count

    @renewal_count = Transaction.where(registration_type: 1)
                                .order(created_at: :desc)
                                .limit(20)
                                .count

    @new_examination_count = Transaction.where(registration_type: 0)
                                        .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                        .order(created_at: :desc)
                                        .limit(20)
                                        .count

    @renewal_examination_count = Transaction.where(registration_type: 1)
                                            .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                            .order(created_at: :desc)
                                            .limit(20)
                                            .count

    @new_certification_count = Transaction.where(registration_type: 0)
                                          .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                          .order(created_at: :desc)
                                          .limit(20)
                                          .count

    @renewal_certification_count = Transaction.where(registration_type: 1)
                                              .where("EXTRACT(YEAR FROM medical_examination_date) = ? AND medical_examination_date < ?", Date.current.year, Date.current)
                                              .order(created_at: :desc)
                                              .limit(20)
                                              .count

    @latest_transactions = Transaction.order(created_at: :desc).limit(20).pluck(:created_at).map { |date| date.strftime("%Y-%m-%d %H:%M:%S") }

    current_year = Date.current.year

    (0..4).each do |i|
      year = current_year - i
      raw_data_for_year = Transaction
                            .where(created_at: (Time.new(year, 1, 1)..Time.new(year, 12, 31, 23, 59, 59)))
                            .order(created_at: :desc)
                            .limit(20)
                            .pluck(:created_at, :medical_examination_date, :certification_date)
                            .map { |record| record.map { |date| date&.strftime("%Y-%m-%d %H:%M:%S") } }

      # Creating  instance variable dynamically
      instance_variable_set("@raw_data_#{year}", raw_data_for_year)
    end

    @sheet_data = generate_dynamic_sheet_data

    respond_to do |format|
      format.xlsx { render xlsx: 'excel_generate', filename: 'ForeignWorker.xlsx' }
    end
  end

  private

  def generate_dynamic_sheet_data
    current_year = Time.now.year
    years = (current_year.downto(current_year - 4)).to_a

    sheet_data = {}

    sheet_data['FW Reg. by Country'] = generate_sheet_data_for_category('FW Registration by Country', years)
    sheet_data['FW Reg. by State'] = generate_sheet_data_for_category('FW Registration by State', years)
    sheet_data['FW Reg. by Sector'] = generate_sheet_data_for_category('FW Registration by Sector', years)
    sheet_data['FW Reg. by Gender'] = generate_sheet_data_for_category('FW Registration by Gender', years)
    sheet_data['FW Reg. by Registration at'] = generate_sheet_data_for_category('FW Registration by Registration at', years)
    sheet_data['FW Reg. by FW Type'] = generate_sheet_data_for_category('FW Registration by FW Type', years)
    sheet_data['Trend of FW Reg. by year'] = ['Trend of FW registration by Year', ['Transaction date by Month', 'Transaction date by Day'] + years.map(&:to_s) + ['Count']]

    years.each do |year|
      sheet_name = "Raw Data #{year}"
      title = "Data #{year}"
      headers = [
        'Transaction Date (Month)', 'Medical Examination Date (Month)', 'Certification Date (Month)',
        'State', 'Country', 'Age', 'Gender', 'Registration at', 'Foreign Worker Type',
        'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)',
        'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)',
        'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)',
        'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)',
        'Medical Review (Received)', 'Medical Review (Reviewed)',
        'Final Result Released', 'Result Transmitted to Immigration',
        'Blocked FW', 'Appeal', 'FW Insured'
      ]

      sheet_data[sheet_name] = [title, headers]
    end

    sheet_data
  end

  def generate_sheet_data_for_category(category_name, years)
    [category_name, [category_name, 'Total FW Registration', 'FW went for medical examination', 'Certification', 'XQCC Pool (Film Received)', 'XQCC Pool (Film Reviewed)', 'PCR Pool (Film Received)', 'PCR Pool (Film Reviewed)', 'X-Ray Pending Review (Film Received)', 'X-Ray Pending Review (Film Reviewed)', 'X-Ray Pending Decision (Film Received)', 'X-Ray Pending Decision (Film Reviewed)', 'Medical Review (Received)', 'Medical Review (Reviewed)', 'Final Result Released', 'Result Transmitted to Immigration', 'Blocked FW', 'Appeal', 'FW Insured']]
  end

  def generate_data_for_countries
    @countries_excel.each do |country|
      cache_key = "country_#{country}_data"

      @country_id = @countries_with_ids[country]

      @total_fw_registration[country] = Rails.cache.fetch("#{cache_key}_total_fw_registration", expires_in: 1.hour) do
        Transaction.where(fw_country_id: @country_id)
                   .order(created_at: :desc)
                   .limit(20)
                   .count
      end

      @examination_count[country] = Rails.cache.fetch("#{cache_key}_examination_count", expires_in: 1.hour) do
        generate_examination_count_data
      end

      @certification_count[country] = Rails.cache.fetch("#{cache_key}_certification_count", expires_in: 1.hour) do
        generate_certification_count_data
      end

      @xqcc_pool_received[country] = Rails.cache.fetch("#{cache_key}_xqcc_pool_received", expires_in: 1.hour) do
        generate_xqcc_pool_received_data
      end

      @xqcc_pool_reviewed[country] = Rails.cache.fetch("#{cache_key}_xqcc_pool_reviewed", expires_in: 1.hour) do
        generate_xqcc_pool_reviewed_data
      end

      @pcr_pool_received[country] = Rails.cache.fetch("#{cache_key}_pcr_pool_received", expires_in: 1.hour) do
        generate_pcr_pool_received_data
      end

      @pcr_pool_reviewed[country] = Rails.cache.fetch("#{cache_key}_pcr_pool_reviewed", expires_in: 1.hour) do
        generate_pcr_pool_reviewed_data
      end

      @xray_pending_review_received[country] = Rails.cache.fetch("#{cache_key}_xray_pending_review_received", expires_in: 1.hour) do
        generate_xray_pending_review_received_data
      end

      @xray_pending_review_reviewed[country] = Rails.cache.fetch("#{cache_key}_xray_pending_review_reviewed", expires_in: 1.hour) do
        generate_xray_pending_review_reviewed_data
      end

      @xray_pending_decision_received[country] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_received", expires_in: 1.hour) do
        generate_xray_pending_decision_received_data
      end

      @xray_pending_decision_reviewed[country] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_reviewed", expires_in: 1.hour) do
        generate_xray_pending_decision_reviewed_data
      end
    end
  end

  def generate_data_for_states

    @states_excel.each do |state|
      cache_key = "state_#{state}_data"

      @doctor_ids = Doctor.where(state_id: @states_with_ids[state]).pluck(:id)

      @total_fw_registration[state] = Rails.cache.fetch("#{cache_key}_total_fw_registration", expires_in: 1.hour) do
        Transaction.where(doctor_id: @doctor_ids)
                   .order(created_at: :desc)
                   .limit(20)
                   .count
      end

      @examination_count[state] = Rails.cache.fetch("#{cache_key}_examination_count", expires_in: 1.hour) do
        generate_examination_count_data
      end

      @certification_count[state] = Rails.cache.fetch("#{cache_key}_certification_count", expires_in: 1.hour) do
        generate_certification_count_data
      end

      @xqcc_pool_received[state] = Rails.cache.fetch("#{cache_key}_xqcc_pool_received", expires_in: 1.hour) do
        generate_xqcc_pool_received_data
      end

      @xqcc_pool_reviewed[state] = Rails.cache.fetch("#{cache_key}_xqcc_pool_reviewed", expires_in: 1.hour) do
        generate_xqcc_pool_reviewed_data
      end

      @pcr_pool_received[state] = Rails.cache.fetch("#{cache_key}_pcr_pool_received", expires_in: 1.hour) do
        generate_pcr_pool_received_data
      end

      @pcr_pool_reviewed[state] = Rails.cache.fetch("#{cache_key}_pcr_pool_reviewed", expires_in: 1.hour) do
        generate_pcr_pool_reviewed_data
      end

      @xray_pending_review_received[state] = Rails.cache.fetch("#{cache_key}_xray_pending_review_received", expires_in: 1.hour) do
        generate_xray_pending_review_received_data
      end

      @xray_pending_review_reviewed[state] = Rails.cache.fetch("#{cache_key}_xray_pending_review_reviewed", expires_in: 1.hour) do
        generate_xray_pending_review_reviewed_data
      end

      @xray_pending_decision_received[state] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_received", expires_in: 1.hour) do
        generate_xray_pending_decision_received_data
      end

      @xray_pending_decision_reviewed[state] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_reviewed", expires_in: 1.hour) do
        generate_xray_pending_decision_reviewed_data
      end

    end
  end

  def generate_data_for_job

    @job_type_excel.each do |job|

      @job_id = @job_type_with_ids[job]

      cache_key = "job_#{job}_data"

      @total_fw_registration[job] = Rails.cache.fetch("#{cache_key}_total_fw_registration", expires_in: 1.hour) do
        Transaction.where(fw_job_type_id: @job_id)
                   .order(created_at: :desc)
                   .limit(20)
                   .count
      end

      @examination_count[job] = Rails.cache.fetch("#{cache_key}_examination_count", expires_in: 1.hour) do
        generate_examination_count_data
      end

      @certification_count[job] = Rails.cache.fetch("#{cache_key}_certification_count", expires_in: 1.hour) do
        generate_certification_count_data
      end

      @xqcc_pool_received[job] = Rails.cache.fetch("#{cache_key}_xqcc_pool_received", expires_in: 1.hour) do
        generate_xqcc_pool_received_data
      end

      @xqcc_pool_reviewed[job] = Rails.cache.fetch("#{cache_key}_xqcc_pool_reviewed", expires_in: 1.hour) do
        generate_xqcc_pool_reviewed_data
      end

      @pcr_pool_received[job] = Rails.cache.fetch("#{cache_key}_pcr_pool_received", expires_in: 1.hour) do
        generate_pcr_pool_received_data
      end

      @pcr_pool_reviewed[job] = Rails.cache.fetch("#{cache_key}_pcr_pool_reviewed", expires_in: 1.hour) do
        generate_pcr_pool_reviewed_data
      end

      @xray_pending_review_received[job] = Rails.cache.fetch("#{cache_key}_xray_pending_review_received", expires_in: 1.hour) do
        generate_xray_pending_review_received_data
      end

      @xray_pending_review_reviewed[job] = Rails.cache.fetch("#{cache_key}_xray_pending_review_reviewed", expires_in: 1.hour) do
        generate_xray_pending_review_reviewed_data
      end

      @xray_pending_decision_received[job] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_received", expires_in: 1.hour) do
        generate_xray_pending_decision_received_data
      end

      @xray_pending_decision_reviewed[job] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_reviewed", expires_in: 1.hour) do
        generate_xray_pending_decision_reviewed_data
      end

    end

  end

  def generate_data_for_organization
    @organizations_excel.each do |organization|
      @organization_id = @organization_with_ids[organization]
      cache_key = "organization_#{organization}_data"

      @total_fw_registration[organization] = Rails.cache.fetch("#{cache_key}_total_fw_registration", expires_in: 1.hour) do
        Transaction.where(organization_id: @organization_id)
                   .order(created_at: :desc)
                   .limit(20)
                   .count
      end

      @examination_count[organization] = Rails.cache.fetch("#{cache_key}_examination_count", expires_in: 1.hour) do
        generate_examination_count_data
      end

      @certification_count[organization] = Rails.cache.fetch("#{cache_key}_certification_count", expires_in: 1.hour) do
        generate_certification_count_data
      end

      @xqcc_pool_received[organization] = Rails.cache.fetch("#{cache_key}_xqcc_pool_received", expires_in: 1.hour) do
        generate_xqcc_pool_received_data
      end

      @xqcc_pool_reviewed[organization] = Rails.cache.fetch("#{cache_key}_xqcc_pool_reviewed", expires_in: 1.hour) do
        generate_xqcc_pool_reviewed_data
      end

      @pcr_pool_received[organization] = Rails.cache.fetch("#{cache_key}_pcr_pool_received", expires_in: 1.hour) do
        generate_pcr_pool_received_data
      end

      @pcr_pool_reviewed[organization] = Rails.cache.fetch("#{cache_key}_pcr_pool_reviewed", expires_in: 1.hour) do
        generate_pcr_pool_reviewed_data
      end

      @xray_pending_review_received[organization] = Rails.cache.fetch("#{cache_key}_xray_pending_review_received", expires_in: 1.hour) do
        generate_xray_pending_review_received_data
      end

      @xray_pending_review_reviewed[organization] = Rails.cache.fetch("#{cache_key}_xray_pending_review_reviewed", expires_in: 1.hour) do
        generate_xray_pending_review_reviewed_data
      end

      @xray_pending_decision_received[organization] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_received", expires_in: 1.hour) do
        generate_xray_pending_decision_received_data
      end

      @xray_pending_decision_reviewed[organization] = Rails.cache.fetch("#{cache_key}_xray_pending_decision_reviewed", expires_in: 1.hour) do
        generate_xray_pending_decision_reviewed_data
      end
    end
  end

  def generate_total_fw_registration_data(country_id = nil, state_id = nil, job_id = nil, organization_id = nil)
    query = Transaction.order(created_at: :desc).limit(20)

    query = query.where(fw_country_id: country_id) if country_id
    query = query.joins(doctor: :state).where('doctors.state_id' => state_id) if state_id
    query = query.where(fw_job_type_id: job_id) if job_id
    query = query.where(organization_id: organization_id) if organization_id
    query.count
  end

  def generate_examination_count_data
    Transaction.where.not(medical_examination_date: nil).order(created_at: :desc).count
  end

  def generate_certification_count_data
    Transaction.where.not(certification_date: nil).order(created_at: :desc).count
  end

  def generate_xqcc_pool_received_data
    Transaction.joins("JOIN xqcc_pools ON xqcc_pools.transaction_id = transactions.id")
               .order('transactions.created_at DESC')
               .limit(20)
               .group('xqcc_pools.created_at, transactions.certification_date, transactions.created_at')
               .count.values
  end

  def generate_xqcc_pool_reviewed_data
    Transaction.joins("JOIN xray_reviews ON xray_reviews.transaction_id = transactions.id")
               .order('transactions.created_at DESC')
               .limit(20)
               .group('xray_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
               .count.values
  end

  def generate_pcr_pool_received_data
    Transaction.joins("JOIN pcr_pools ON pcr_pools.transaction_id = transactions.id").order('transactions.created_at DESC')
               .limit(20)
               .group('pcr_pools.created_at, transactions.certification_date, transactions.created_at')
               .count.values
  end

  def generate_pcr_pool_reviewed_data
    Transaction.joins("JOIN pcr_reviews ON pcr_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
               .limit(20)
               .group('pcr_reviews.created_at,transactions.certification_date, transactions.created_at')
               .count.values
  end

  def generate_xray_pending_review_received_data
    Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
               .limit(20)
               .group('xray_pending_reviews.created_at, transactions.certification_date, transactions.created_at')
               .count.values
  end

  def generate_xray_pending_review_reviewed_data
    Transaction.joins("JOIN xray_pending_reviews ON xray_pending_reviews.transaction_id = transactions.id").order('transactions.created_at DESC')
               .limit(20)
               .group('xray_pending_reviews.transmitted_at, transactions.certification_date, transactions.created_at')
               .count.values
  end

  def generate_xray_pending_decision_received_data
    Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
               .limit(20)
               .group('xray_pending_decisions.created_at, transactions.certification_date, transactions.created_at')
               .count.values

  end

  def generate_xray_pending_decision_reviewed_data
    Transaction.joins("JOIN xray_pending_decisions ON xray_pending_decisions.transaction_id = transactions.id").order('transactions.created_at DESC')
               .limit(20)
               .group('xray_pending_decisions.transmitted_at, transactions.certification_date, transactions.created_at')
               .count.values
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