class Dashboards::FwInformationController < InternalController
  # layout "application"

  def index
    # Filters Data
    @countries = specific_countries
    @states = Rails.cache.fetch("state_names", expires_in: 1.day) { State.order(:name).pluck(:id, :name) }
    @job_type = JobType.order(:name).pluck(:id, :name) # Sectors
    @foregin_worker_type = Transaction.registration_types.keys # Foreign Worker Type
    @organizations = Organization.order(:name).where(status: 'ACTIVE').pluck(:name)

    respond_to do |format|
      format.html
      format.js { render layout: false } # Add this line to you respond_to block
    end
  end

  def registration_counts
    filters = params[:data]
    filtered_data = if filters.present?
                      filtered_transactions(params[:data])
                    else
                      @fw_registration = Transaction.where.not(transaction_date: nil).where.not(status: ['CANCELLED', 'REJECTED']).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @fw_medical_examination = Transaction.where.not(medical_examination_date: nil).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @fw_certification = Transaction.where.not(certification_date: nil).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @final_result_release = Transaction.where.not(transaction_date: nil).where.not(final_result_date: nil).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @result_transmit_immigration = Transaction.joins("JOIN myimms_transactions ON myimms_transactions.transaction_id = transactions.id").where.not(myimms_transactions: { transaction_id: nil }).where.not(myimms_transactions: { status: nil }).where.not(final_result_date: nil).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @fw_blocked = Transaction.joins("JOIN myimms_transactions ON myimms_transactions.transaction_id = transactions.id").where.not(myimms_transactions: { transaction_id: nil }).where.not(myimms_transactions: { status: nil }).where.not(myimms_transactions: { status: 1 }).where.not(final_result_date: nil).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @fw_appeal = Transaction.joins(:medical_appeals).where.not(medical_appeals: { created_at: nil }).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @fw_insured = Transaction.joins(" INNER JOIN insurance_purchases ON transactions.foreign_worker_id =insurance_purchases.foreign_worker_id INNER JOIN orders ON insurance_purchases.order_id = orders.id").where.not('insurance_purchases.foreign_worker_id' => nil, 'orders.id' => nil, 'transactions.transaction_date' => nil).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).count
                      @fw_pending_view = {
                        xqcc_pool_received: Transaction.joins(:xqcc_pools).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(xqcc_pools: { created_at: nil }).where.not(certification_date: nil).count,
                        xqcc_pool_reviewed: Transaction.joins(:xray_reviews, :xqcc_pools).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(xqcc_pools: { created_at: nil }).where.not(xray_reviews: { transmitted_at: nil }).count,
                        pcr_pool_received: Transaction.joins(:pcr_pools).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(pcr_pools: { created_at: nil }).where.not(certification_date: nil).count,
                        pcr_pool_reviewed: Transaction.joins(:pcr_reviews, :pcr_pools).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(pcr_pools: { created_at: nil }).where.not(pcr_reviews: { transmitted_at: nil }).count,
                        xray_pending_review_received: Transaction.joins(:xray_pending_reviews).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(xray_pending_reviews: { created_at: nil }).where.not(certification_date: nil).count,
                        xray_pending_review_reviewed: Transaction.joins(:xray_pending_reviews).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(xray_pending_reviews: { created_at: nil }).where.not(xray_pending_reviews: { transmitted_at: nil }).where.not(certification_date: nil).count,
                        xray_pending_decision_received: Transaction.joins(:xray_pending_decisions).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(xray_pending_decisions: { created_at: nil }).where.not(certification_date: nil).count,
                        xray_pending_decision_reviewed: Transaction.joins(:xray_pending_decisions).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(xray_pending_decisions: { created_at: nil }).where.not(xray_pending_decisions: { transmitted_at: nil }).where.not(certification_date: nil).count,
                        medical_review_received: Transaction.joins(:medical_reviews).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(medical_reviews: { created_at: nil }).where.not(certification_date: nil).count,
                        medical_review_reviewed: Transaction.joins(:medical_reviews).where("EXTRACT(YEAR FROM transactions.created_at) = ?", Date.today.year).where.not(medical_reviews: { medical_mle1_decision_at: nil }).where(medical_reviews: { is_qa: 'TRUE' }).where.not(medical_reviews: { qa_decision_at: nil }).count
                      }
                      @fw_pending_view_count = @fw_pending_view.values.sum
                    end
    filtered_data

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

                      all_reg_by_countries = Transaction
                                               .joins("JOIN countries ON countries.id = transactions.fw_country_id")
                                               .group('countries.name', 'countries.code')
                                               .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                               .select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count")
                                               .map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

                      if all_reg_by_countries.nil? || all_reg_by_countries.empty?
                        @fw_Reg_by_countries = nil
                      else
                        allowed_countries_data = all_reg_by_countries.select { |entry| allowed_countries.include?(entry[0].upcase) }

                        others_count = all_reg_by_countries.reject { |entry| allowed_countries.include?(entry[0].upcase) }
                                                           .map { |entry| entry[2] }
                                                           .sum
                        @fw_Reg_by_countries = (allowed_countries_data + [["OTHERS", "OTH", others_count]]).sort_by! { |entry| entry[0] }
                      end
                    end

    filtered_data

    render layout: false
  end

  def registration_trends
    filtered_data = if params[:data].present?
                      filtered_transactions(params[:data])
                    else
                      @transaction_line_chart = Transaction.transaction_data_last_5_years rescue {}
                      if @transaction_line_chart.blank?
                        current_year = start_of_curr_year.year
                        last_five_years = (current_year - 4..current_year)

                        @transaction_line_chart = last_five_years.each_with_object({}) do |year, chart_data|
                          chart_data[year] = [0] * 12
                        end
                      end
                      @sums_by_year = @transaction_line_chart.transform_values { |data| data.sum }

                    end

    filtered_data
    
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
    transactions = apply_date_range_filter(filters, transactions)
    start_time, end_time = date_range_values(filters)

    allowed_countries = ['BANGLADESH', 'NEPAL', 'INDONESIA', 'MYANMAR', 'INDIA',
                         'PAKISTAN', 'PHILIPPINES', 'VIETNAM', 'SRI LANKA', 'THAILAND', 'CAMBODIA', 'LAOS',
                         'UZBEKISTAN', 'TURKMENISTAN', 'KAZAKHSTAN']

    base_query_trend_fw = Transaction.where(created_at: start_time..end_time)
    base_query_sectors = Transaction.joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time)
    base_query_states = Transaction.joins(doctor: :state).where(created_at: start_time..end_time)
    base_query_countries = Transaction.joins("JOIN countries ON countries.id = transactions.fw_country_id").where(created_at: start_time..end_time)

    # side view section

    base_query_fw_registration = Transaction.where.not(transaction_date: nil).where.not(status: ['CANCELLED', 'REJECTED']).where(created_at: start_time..end_time)
    base_query_fw_medical_examination = Transaction.where.not(medical_examination_date: nil).where(created_at: start_time..end_time)
    base_query_fw_certification = Transaction.where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_final_result_release = Transaction.where.not(transaction_date: nil).where.not(final_result_date: nil)
    base_query_result_transmit_immigration = Transaction.joins("JOIN myimms_transactions ON myimms_transactions.transaction_id = transactions.id").where.not(myimms_transactions: { transaction_id: nil }).where.not(myimms_transactions: { status: nil }).where.not(final_result_date: nil).where(created_at: start_time..end_time)
    base_query_fw_blocked = Transaction.joins("JOIN myimms_transactions ON myimms_transactions.transaction_id = transactions.id").where.not(myimms_transactions: { transaction_id: nil }).where.not(myimms_transactions: { status: nil }).where.not(myimms_transactions: { status: 1 }).where.not(final_result_date: nil).where(created_at: start_time..end_time)
    base_query_fw_appeal = Transaction.joins(:medical_appeals).where.not(medical_appeals: { created_at: nil }).where(created_at: start_time..end_time)
    base_query_fw_insured = Transaction.joins(" INNER JOIN insurance_purchases ON transactions.foreign_worker_id =insurance_purchases.foreign_worker_id INNER JOIN orders ON insurance_purchases.order_id = orders.id").where.not('insurance_purchases.foreign_worker_id' => nil, 'orders.id' => nil, 'transactions.transaction_date' => nil).where(created_at: start_time..end_time)

    # fomema pending to view section

    base_query_xqcc_pool_received = Transaction.joins(:xqcc_pools).where.not(xqcc_pools: { created_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_xqcc_pool_reviewed = Transaction.joins(:xray_reviews, :xqcc_pools).where.not(xqcc_pools: { created_at: nil }).where.not(xray_reviews: { transmitted_at: nil }).where(created_at: start_time..end_time)
    base_query_pcr_pool_received = Transaction.joins(:pcr_pools).where.not(pcr_pools: { created_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_pcr_pool_reviewed = Transaction.joins(:pcr_reviews, :pcr_pools).where.not(pcr_pools: { created_at: nil }).where.not(pcr_reviews: { transmitted_at: nil }).where(created_at: start_time..end_time)
    base_query_xray_pending_review_received = Transaction.joins(:xray_pending_reviews).where.not(xray_pending_reviews: { created_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_xray_pending_review_reviewed = Transaction.joins(:xray_pending_reviews).where.not(xray_pending_reviews: { created_at: nil }).where.not(xray_pending_reviews: { transmitted_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_xray_pending_decision_received = Transaction.joins(:xray_pending_decisions).where.not(xray_pending_decisions: { created_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_xray_pending_decision_reviewed = Transaction.joins(:xray_pending_decisions).where.not(xray_pending_decisions: { created_at: nil }).where.not(xray_pending_decisions: { transmitted_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_medical_review_received = Transaction.joins(:medical_reviews).where.not(medical_reviews: { created_at: nil }).where.not(certification_date: nil).where(created_at: start_time..end_time)
    base_query_medical_review_reviewed = Transaction.joins(:medical_reviews).where.not(medical_reviews: { medical_mle1_decision_at: nil }).where(medical_reviews: { is_qa: 'TRUE' }).where.not(medical_reviews: { qa_decision_at: nil }).where(created_at: start_time..end_time)

    if filters[:sectors].present?

      transactions = transactions.joins("JOIN job_types on transactions.fw_job_type_id = job_types.id").where(created_at: start_time..end_time).where(job_types: { id: filters[:sectors] })

      base_query_trend_fw = base_query_trend_fw.where(fw_job_type_id: filters[:sectors])

      base_query_sectors = transactions

      # sector data to display in state

      base_query_states = base_query_states.where(fw_job_type_id: filters[:sectors])

      # sector data to display in country

      country_ids = transactions.pluck(:fw_country_id).uniq

      base_query_countries = base_query_countries.where(fw_country_id: country_ids).where(fw_job_type_id: filters[:sectors])

      # side section
      base_query_fw_registration = base_query_fw_registration.where(fw_job_type_id: filters[:sectors])
      base_query_fw_medical_examination = base_query_fw_medical_examination.where(fw_job_type_id: filters[:sectors])
      base_query_fw_certification = base_query_fw_certification.where(fw_job_type_id: filters[:sectors])
      base_query_final_result_release = base_query_final_result_release.where(fw_job_type_id: filters[:sectors])
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.where(fw_job_type_id: filters[:sectors])
      base_query_fw_blocked = base_query_fw_blocked.where(fw_job_type_id: filters[:sectors])
      base_query_fw_appeal = base_query_fw_appeal.where(fw_job_type_id: filters[:sectors])
      base_query_fw_insured = base_query_fw_insured.where(fw_job_type_id: filters[:sectors])

      # # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.where(fw_job_type_id: filters[:sectors])
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.where(fw_job_type_id: filters[:sectors])
      base_query_pcr_pool_received = base_query_pcr_pool_received.where(fw_job_type_id: filters[:sectors])
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.where(fw_job_type_id: filters[:sectors])
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.where(fw_job_type_id: filters[:sectors])
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.where(fw_job_type_id: filters[:sectors])
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.where(fw_job_type_id: filters[:sectors])
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.where(fw_job_type_id: filters[:sectors])
      base_query_medical_review_received = base_query_medical_review_received.where(fw_job_type_id: filters[:sectors])
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.where(fw_job_type_id: filters[:sectors])

    end

    if filters[:states].present?

      base_query_trend_fw = base_query_trend_fw.joins(doctor: :state).where(states: { id: filters[:states] })

      base_query_states = base_query_states.where(states: { id: filters[:states] })

      # state data to display in sector
      base_query_sectors = base_query_sectors.joins(doctor: :state).where(states: { id: filters[:states] })

      # state data to display in country
      doctor_ids = Doctor.where(state_id: filters[:states]).pluck(:id).compact.uniq
      country_ids = Transaction.where(doctor_id: doctor_ids).pluck(:fw_country_id).compact.uniq

      base_query_countries = base_query_countries.joins(doctor: :state).where(states: { id: filters[:states] }).where(fw_country_id: country_ids)

      # side section
      base_query_fw_registration = base_query_fw_registration.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_fw_medical_examination = base_query_fw_medical_examination.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_fw_certification = base_query_fw_certification.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_final_result_release = base_query_final_result_release.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_fw_blocked = base_query_fw_blocked.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_fw_appeal = base_query_fw_appeal.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_fw_insured = base_query_fw_insured.joins(doctor: :state).where(states: { id: filters[:states] })

      # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_pcr_pool_received = base_query_pcr_pool_received.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_medical_review_received = base_query_medical_review_received.joins(doctor: :state).where(states: { id: filters[:states] })
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.joins(doctor: :state).where(states: { id: filters[:states] })

    end

    if filters[:countries].present?
      country_ids = filters[:countries]
      base_query_countries = base_query_countries.where(fw_country_id: country_ids)

      base_query_trend_fw = base_query_trend_fw.where(fw_country_id: filters[:countries])

      # country data to display in sectors
      base_query_sectors = base_query_sectors.where(fw_country_id: country_ids)

      # country data to display in states
      base_query_states = base_query_states.where(fw_country_id: country_ids)

      # side section
      base_query_fw_registration = base_query_fw_registration.where(fw_country_id: country_ids)
      base_query_fw_medical_examination = base_query_fw_medical_examination.where(fw_country_id: country_ids)
      base_query_fw_certification = base_query_fw_certification.where(fw_country_id: country_ids)
      base_query_final_result_release = base_query_final_result_release.where(fw_country_id: country_ids)
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.where(fw_country_id: country_ids)
      base_query_fw_blocked = base_query_fw_blocked.where(fw_country_id: country_ids)
      base_query_fw_appeal = base_query_fw_appeal.where(fw_country_id: country_ids)
      base_query_fw_insured = base_query_fw_insured.where(fw_country_id: country_ids)

      # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.where(fw_country_id: country_ids)
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.where(fw_country_id: country_ids)
      base_query_pcr_pool_received = base_query_pcr_pool_received.where(fw_country_id: country_ids)
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.where(fw_country_id: country_ids)
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.where(fw_country_id: country_ids)
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.where(fw_country_id: country_ids)
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.where(fw_country_id: country_ids)
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.where(fw_country_id: country_ids)
      base_query_medical_review_received = base_query_medical_review_received.where(fw_country_id: country_ids)
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.where(fw_country_id: country_ids)

    elsif filters[:other_countries].to_s == 'true'

      country_ids = allowed_countries.map { |country| Country.find_by(name: country)&.id }.compact
      base_query_countries = base_query_countries.where.not(fw_country_id: country_ids)
      base_query_trend_fw = base_query_trend_fw.where.not(fw_country_id: country_ids)
    end

    if filters[:age].present?
      filtered_age_ranges = filters[:age]

      # Calculate birth year ranges based on the provided age ranges
      conditions = filtered_age_ranges.map do |range|
        min_age, max_age = range.split('-').map(&:to_i)
        "EXTRACT(YEAR FROM AGE(CURRENT_DATE, transactions.fw_date_of_birth)) BETWEEN ? AND ?"
      end.join(" OR ")

      transactions = Transaction.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

      base_query_trend_fw = base_query_trend_fw.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

      # age data to display in sectors
      base_query_sectors = base_query_sectors.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

      # age data to display in states
      base_query_states = base_query_states.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

      # age data to display in countries
      country_ids = base_query_countries.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) }).pluck(:fw_country_id).compact.uniq

      base_query_countries = base_query_countries.where(fw_country_id: country_ids).where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

      # side section
      base_query_fw_registration = base_query_fw_registration.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_fw_medical_examination = base_query_fw_medical_examination.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_fw_certification = base_query_fw_certification.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_final_result_release = base_query_final_result_release.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_fw_blocked = base_query_fw_blocked.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_fw_appeal = base_query_fw_appeal.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_fw_insured = base_query_fw_insured.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

      # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_pcr_pool_received = base_query_pcr_pool_received.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_medical_review_received = base_query_medical_review_received.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.where(conditions, *filtered_age_ranges.flat_map { |range| range.split('-').map(&:to_i) })

    end

    if filters[:gender].present?

      base_query_trend_fw = base_query_trend_fw.where(fw_gender: filters[:gender])

      # gender data to display in sectors
      base_query_sectors = base_query_sectors.where(fw_gender: filters[:gender])

      # gender data to display in states
      base_query_states = base_query_states.where(fw_gender: filters[:gender])

      # gender data to display in countries
      country_ids = base_query_countries.where(fw_gender: filters[:gender]).pluck(:fw_country_id).compact.uniq

      base_query_countries = base_query_countries.where(fw_country_id: country_ids).where(fw_gender: filters[:gender])

      base_query_fw_registration = base_query_fw_registration.where(fw_gender: filters[:gender])
      base_query_fw_medical_examination = base_query_fw_medical_examination.where(fw_gender: filters[:gender])
      base_query_fw_certification = base_query_fw_certification.where(fw_gender: filters[:gender])
      base_query_final_result_release = base_query_final_result_release.where(fw_gender: filters[:gender])
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.where(fw_gender: filters[:gender])
      base_query_fw_blocked = base_query_fw_blocked.where(fw_gender: filters[:gender])
      base_query_fw_appeal = base_query_fw_appeal.where(fw_gender: filters[:gender])
      base_query_fw_insured = base_query_fw_insured.where(fw_gender: filters[:gender])

      # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.where(fw_gender: filters[:gender])
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.where(fw_gender: filters[:gender])
      base_query_pcr_pool_received = base_query_pcr_pool_received.where(fw_gender: filters[:gender])
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.where(fw_gender: filters[:gender])
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.where(fw_gender: filters[:gender])
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.where(fw_gender: filters[:gender])
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.where(fw_gender: filters[:gender])
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.where(fw_gender: filters[:gender])
      base_query_medical_review_received = base_query_medical_review_received.where(fw_gender: filters[:gender])
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.where(fw_gender: filters[:gender])

    end

    if filters[:fw_types].present?
      registration_type_values = {
        "new" => 0,
        "renewal" => 1
      }

      base_query_trend_fw = base_query_trend_fw.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))

      # registration data to display in sectors
      base_query_sectors = base_query_sectors.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))

      # registration data to display in states
      base_query_states = base_query_states.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))

      # registration data to display in countries

      country_ids = base_query_countries.where(registration_type: registration_type_values.values_at(*filters[:fw_types])).pluck(:fw_country_id).compact.uniq

      base_query_countries = base_query_countries.where(fw_country_id: country_ids).where(registration_type: registration_type_values.values_at(*filters[:fw_types]))

      # side section
      base_query_fw_registration = base_query_fw_registration.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_fw_medical_examination = base_query_fw_medical_examination.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_fw_certification = base_query_fw_certification.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_final_result_release = base_query_final_result_release.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_fw_blocked = base_query_fw_blocked.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_fw_appeal = base_query_fw_appeal.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_fw_insured = base_query_fw_insured.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))

      # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_pcr_pool_received = base_query_pcr_pool_received.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_medical_review_received = base_query_medical_review_received.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.where(registration_type: registration_type_values.values_at(*filters[:fw_types]))

    end

    if filters[:registration_types].present?
      organization_ids = Organization.where(name: filters[:registration_types]).pluck(:id)

      base_query_trend_fw = base_query_trend_fw.where(organization_id: organization_ids)

      # registration_types data to display in sectors
      base_query_sectors = base_query_sectors.where(organization_id: organization_ids)

      # registration_types data to display in states
      base_query_states = base_query_states.where(organization_id: organization_ids)

      # registration_types data to display in countries

      country_ids = base_query_countries.where(organization_id: organization_ids).pluck(:fw_country_id).compact.uniq

      base_query_countries = base_query_countries.where(fw_country_id: country_ids).where(organization_id: organization_ids)

      # side section
      base_query_fw_registration = base_query_fw_registration.where(organization_id: organization_ids)
      base_query_fw_medical_examination = base_query_fw_medical_examination.where(organization_id: organization_ids)
      base_query_fw_certification = base_query_fw_certification.where(organization_id: organization_ids)
      base_query_final_result_release = base_query_final_result_release.where(organization_id: organization_ids)
      base_query_result_transmit_immigration = base_query_result_transmit_immigration.where(organization_id: organization_ids)
      base_query_fw_blocked = base_query_fw_blocked.where(organization_id: organization_ids)
      base_query_fw_appeal = base_query_fw_appeal.where(organization_id: organization_ids)
      base_query_fw_insured = base_query_fw_insured.where(organization_id: organization_ids)

      # fomema pending to view
      base_query_xqcc_pool_received = base_query_xqcc_pool_received.where(organization_id: organization_ids)
      base_query_xqcc_pool_reviewed = base_query_xqcc_pool_reviewed.where(organization_id: organization_ids)
      base_query_pcr_pool_received = base_query_pcr_pool_received.where(organization_id: organization_ids)
      base_query_pcr_pool_reviewed = base_query_pcr_pool_reviewed.where(organization_id: organization_ids)
      base_query_xray_pending_review_received = base_query_xray_pending_review_received.where(organization_id: organization_ids)
      base_query_xray_pending_review_reviewed = base_query_xray_pending_review_reviewed.where(organization_id: organization_ids)
      base_query_xray_pending_decision_received = base_query_xray_pending_decision_received.where(organization_id: organization_ids)
      base_query_xray_pending_decision_reviewed = base_query_xray_pending_decision_reviewed.where(organization_id: organization_ids)
      base_query_medical_review_received = base_query_medical_review_received.where(organization_id: organization_ids)
      base_query_medical_review_reviewed = base_query_medical_review_reviewed.where(organization_id: organization_ids)

    end

    # line chart
    @transaction_line_chart = Transaction.transaction_data_between(base_query_trend_fw)
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

    all_reg_by_countries = base_query_countries.group('countries.name', 'countries.code').select("countries.name || ',' || countries.code AS country_info, COUNT(*) AS count").map { |entry| entry.country_info.split(',') + [entry.count.to_i] }

    if all_reg_by_countries.nil? || all_reg_by_countries.empty?
      @fw_Reg_by_countries = nil
    else
      allowed_countries_data = all_reg_by_countries.select { |entry| allowed_countries.include?(entry[0].upcase) }

      if filters[:countries].present?
        @fw_Reg_by_countries = allowed_countries_data.sort_by! { |entry| entry[0] }
      else
        others_count = all_reg_by_countries.reject { |entry| allowed_countries.include?(entry[0].upcase) }
                                           .map { |entry| entry[2] }
                                           .sum
        @fw_Reg_by_countries = (allowed_countries_data + [["OTHERS", "OTH", others_count]]).sort_by! { |entry| entry[0] }
      end

    end

    job_types_count = base_query_sectors.
      group('job_types.name').
      pluck('job_types.name', 'COUNT(1)')
    @pi_chart_filtered_data = [['Task', 'Hours per Day'], *job_types_count]

    @fw_reg_by_filtered_states = base_query_states
                                   .group('states.id')
                                   .pluck('states.name, states.long_code, COUNT(*)')
                                   .map { |name, long_code, count| { name: name, long_code: long_code, count: count } }

    # side view
    @fw_registration = base_query_fw_registration.count
    @fw_medical_examination = base_query_fw_medical_examination.count
    @fw_certification = base_query_fw_certification.count
    @final_result_release = base_query_final_result_release.count
    @result_transmit_immigration = base_query_result_transmit_immigration.count
    @fw_blocked = base_query_fw_blocked.count
    @fw_appeal = base_query_fw_appeal.count
    @fw_insured = base_query_fw_insured.count
    @fw_pending_view = {
      xqcc_pool_received: base_query_xqcc_pool_received.count,
      xqcc_pool_reviewed: base_query_xqcc_pool_reviewed.count,
      pcr_pool_received: base_query_pcr_pool_received.count,
      pcr_pool_reviewed: base_query_pcr_pool_reviewed.count,
      xray_pending_review_received: base_query_xray_pending_review_received.count,
      xray_pending_review_reviewed: base_query_xray_pending_review_reviewed.count,
      xray_pending_decision_received: base_query_xray_pending_decision_received.count,
      xray_pending_decision_reviewed: base_query_xray_pending_decision_reviewed.count,
      medical_review_received: base_query_medical_review_received.count,
      medical_review_reviewed: base_query_medical_review_reviewed.count
    }
    @fw_pending_view_count = @fw_pending_view.values.sum

    transactions
  end

  def apply_date_range_filter(filters, transactions)
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
