class Dashboards::DepInformationController < InternalController
  def index
    @task_list = tasks
    result_key
    page_number = params[:page] || 1
    #@users = User.where("users.status='ACTIVE'").select(:name, :designation).all
  end

  def third_db_data
    @params = JSON.parse(params.keys.first)
    page_number = params[:page] || 1
    @task_list = tasks
    result_key
    #@users = User.where("users.status='ACTIVE'").select(:name, :designation).all
  end

  def filter_kpi
    date_range = params[:dateRange]
    start_date_str, end_date_str = date_range.split(' - ').map(&:strip)

    # Parse the date strings into Date objects
    start_date = Date.strptime(start_date_str, '%d/%m/%Y')
    end_date = Date.strptime(end_date_str, '%d/%m/%Y')

    management_of_service_provider = {}
    total_kpi_percentage = 0
    tat_values_sp = [10, 14]

    tat_values_sp.each do |tat|
      doctor_achieved = Doctor.where("registration_approved_at <= created_at + interval '? days'", tat).where("created_at BETWEEN ? AND ?", start_date, end_date).count
      doctor_not_achieved = Doctor.where("registration_approved_at > created_at + interval '? days'", tat).where("created_at BETWEEN ? AND ?", start_date, end_date).count
      xray_achieved = XrayFacility.where("registration_approved_at <= created_at + interval '? days'", tat).where("created_at BETWEEN ? AND ?", start_date, end_date).count
      xray_not_achieved = XrayFacility.where("registration_approved_at > created_at + interval '? days'", tat).where("created_at BETWEEN ? AND ?", start_date, end_date).count
      lab_achived = Laboratory.where("registration_approved_at <= created_at + interval '? days'", tat).where("created_at BETWEEN ? AND ?", start_date, end_date).count
      lab_not_achieved = Laboratory.where("registration_approved_at > created_at + interval '? days'", tat).where("created_at BETWEEN ? AND ?", start_date, end_date).count

      achieved_count = doctor_achieved + xray_achieved + lab_achived
      not_achieved_count = doctor_not_achieved + xray_not_achieved + lab_not_achieved

      total_count = achieved_count + not_achieved_count
      kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0

      total_kpi_percentage += kpi_percentage

      management_of_service_provider[tat] = { achieved_count: achieved_count, not_achieved_count: not_achieved_count, total_count: total_count, kpi_percentage: kpi_percentage.round(1) }
    end

    management_of_service_provider.each do |tat, values|
      achieved_count = values[:achieved_count]
      not_achieved_count = values[:not_achieved_count]
      total_count = values[:total_count]
      kpi_percentage = values[:kpi_percentage]
    end
    average_kpi_10 = management_of_service_provider[10][:kpi_percentage]
    average_kpi_14 = management_of_service_provider[14][:kpi_percentage]
    average = average_kpi_10 + average_kpi_14
    management_of_sp_average = (average / 2).round(1).zero? ? 0 : (average / 2).round(1)

    total_visit = 0 # VisitReport.where(visit_date: start_date..end_date).count
    total_active_lab = Laboratory.where(status: 'ACTIVE').count
    total_active_doc = Laboratory.where(status: 'ACTIVE').count
    total_active_xray = XrayFacility.where(status: 'ACTIVE').count

    kpi_percentage_xray_visit = (total_active_xray > 0 ? (total_active_xray.to_f / total_visit) * 100 : 0).round(1)

    kpi_percentage_doc_visit = (total_active_doc > 0 ? (total_active_doc.to_f / total_visit) * 100 : 0).round(1)

    lqcc_kpi = (total_active_lab > 0 ? (total_active_lab.to_f / total_visit) * 100 : 0).round(1)

    if total_visit > 0
      inpectorate_average = ((kpi_percentage_xray_visit + kpi_percentage_doc_visit) / 2).round(1)
    else
      inpectorate_average = 0
    end

    change_emp_achieved_count = FwChangeEmployer.where("approval_at <= requested_at + interval '? days'", 3).where("created_at BETWEEN ? AND ?", start_date, end_date).count
    change_emp_not_achieved_count = FwChangeEmployer.where("approval_at > requested_at + interval '? days'", 3).where("created_at BETWEEN ? AND ?", start_date, end_date).count

    if (change_emp_achieved_count + change_emp_not_achieved_count) > 0
      change_emp_kpi = (change_emp_achieved_count.to_f / (change_emp_achieved_count + change_emp_not_achieved_count)).round(1)
    else
      change_emp_kpi = 0
    end

    tat_values_amend = [2, 3]
    total_kpi_percentage = 0
    amend_info = {}

    tat_values_amend.each do |tat|
      achieved_count = FwChangeEmployer.where("approval_at <= requested_at + interval '? days'", tat.to_i).where("created_at BETWEEN ? AND ?", start_date, end_date).count
      not_achieved_count = FwChangeEmployer.where("approval_at > requested_at + interval '? days'", tat.to_i).where("created_at BETWEEN ? AND ?", start_date, end_date).count

      total_count = achieved_count + not_achieved_count
      kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0

      total_kpi_percentage += kpi_percentage

      amend_info[tat] = { achieved_count: achieved_count, not_achieved_count: not_achieved_count, total_count: total_count, kpi_percentage: kpi_percentage.round(1) }
    end

    amend_info.each do |tat, values|
      achieved_count = values[:achieved_count]
      not_achieved_count = values[:not_achieved_count]
      total_count = values[:total_count]
      kpi_percentage = values[:kpi_percentage]
    end

    # Handle division by zero error for amend_info[3]
    amend_info_total_kpi_for_tat_3 = amend_info[3] ? amend_info[3][:kpi_percentage] : 0

    # Set amend_info_total_kpi_for_tat_3 to 0 if it is 0.0
    amend_info_total_kpi_for_tat_3 = 0 if amend_info_total_kpi_for_tat_3 == 0.0

    regional_office_avg_kpi = ((change_emp_kpi + amend_info_total_kpi_for_tat_3 * 4) / 5).round(1)

    emp_achieved_count = Employer.where("created_at <= registration_approved_at + interval '? days'", 2).where("created_at BETWEEN ? AND ?", start_date, end_date).count
    emp_not_achieved_count = Employer.where("created_at > registration_approved_at + interval '? days'", 2).where("created_at BETWEEN ? AND ?", start_date, end_date).count

    if (emp_achieved_count + emp_not_achieved_count) > 0
      emp_kpi = (emp_achieved_count.to_f / (emp_achieved_count + emp_not_achieved_count)).round(1)
    else
      emp_kpi = 0
    end

    agency_achieved_count = Agency.where("created_at <= registration_approved_at + interval '? days'", 14).where("created_at BETWEEN ? AND ?", start_date, end_date).count
    agency_not_achieved_count = Agency.where("created_at > registration_approved_at + interval '? days'", 14).where("created_at BETWEEN ? AND ?", start_date, end_date).count

    # Calculate agency_kpi
    if (agency_achieved_count + agency_not_achieved_count) > 0
      agency_kpi = (agency_achieved_count.to_f / (agency_achieved_count + agency_not_achieved_count)).round(1)
    else
      agency_kpi = 0
    end

    amend_info_total_kpi_for_tat_2 = amend_info[2] ? amend_info[2][:kpi_percentage] : 0

    amend_info_total_kpi_for_tat_2 = 0 if amend_info_total_kpi_for_tat_2 == 0.0

    support_service_avg_kpi = ((emp_kpi + agency_kpi + change_emp_kpi + amend_info_total_kpi_for_tat_2 + amend_info_total_kpi_for_tat_3) / 5).round(1)

    xray_achieved = Transaction.joins("INNER JOIN xray_reviews ON xray_reviews.id = transactions.xray_review_id").where("xray_reviews.created_at <= transactions.certification_date + INTERVAL '3' DAY").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

    xray_not_achieved = Transaction.joins("INNER JOIN xray_reviews ON xray_reviews.id = transactions.xray_review_id").where("xray_reviews.created_at > transactions.certification_date + INTERVAL '3' DAY").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

    xray_total = xray_achieved + xray_not_achieved

    xray_kpi = xray_total.zero? ? 0.0 : (xray_achieved.to_f / xray_total).round(1)

    pcr_achieved = PcrReview.joins("INNER JOIN transactions ON transactions.pcr_review_id = pcr_reviews.id").where("pcr_reviews.transmitted_at <= (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count
    pcr_not_achieved = PcrReview.joins("INNER JOIN transactions ON transactions.pcr_review_id = pcr_reviews.id").where("pcr_reviews.transmitted_at > (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

    pcr_total = pcr_achieved + pcr_not_achieved

    pcr_kpi = pcr_total.zero? ? 0.0 : (pcr_achieved.to_f / pcr_total).round(1)

    xqcc_amendment_achieved = XrayPendingReview.joins("INNER JOIN transactions ON transactions.xray_pending_review_id = xray_pending_reviews.id").where("xray_pending_reviews.transmitted_at <= (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

    xqcc_amendment_not_achieved = XrayPendingDecision.joins("INNER JOIN transactions ON transactions.xray_pending_decision_id = xray_pending_decisions.id").where("xray_pending_decisions.transmitted_at <= (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

    xqcc_amendment_total = xqcc_amendment_achieved + xqcc_amendment_not_achieved

    xqcc_amendment_kpi = xqcc_amendment_total.zero? ? 0.0 : (xqcc_amendment_achieved.to_f / xqcc_amendment_total).round(1)

    xray_qcc_kpi = (xray_kpi + pcr_kpi + xqcc_amendment_kpi) / 3.0
    xray_qcc_kpi = 0.0 if xray_qcc_kpi.nan?

    results = {
      management_of_sp_average: management_of_sp_average.round(1),
      human_capital_average: 0,
      inpectorate_average: inpectorate_average.round(1),
      xray_qcc: xray_qcc_kpi.round(1),
      medical_review_appeal: 0,
      finance_adm: 0,
      regional_office_avg_kpi: regional_office_avg_kpi.round(1),
      customer_service: 0,
      lqcc: lqcc_kpi.round(1),
      suppor_service_avg_kpi: support_service_avg_kpi.round(1)
    }

    render json: results

  end

  def result_key
    @kpi_data = {
      customer_service: @task_list.select { |hash| ["Email", "Chat", "Bypass fingerprint approval"].include?(hash[:task]) },
      support_service: @task_list.select do |hash|
        ["Employer Registration", "Agency Registration", "Foreign Worker Amendment", "Change Employer (transfer worker)", "Update Employer Detail Approval (Employer)"].include?(hash[:task]) ||
          (hash[:task] == 'Special Renewal Approval (unfit)' && hash[:TAT] == '2wd')
      end,
      xray_quality: @task_list.select { |hash| ["Review - Normal chest X-ray", "Audit - Abnormal chest X-ray", "XQCC Amendment"].include?(hash[:task]) },
      laboratory_quality: @task_list.select { |hash| ["Laboratory"].include?(hash[:task]) },
      inspectorate: @task_list.select { |hash| ["Doctor Visit", "X-ray Visit"].include?(hash[:task]) },
      finance_admin: @task_list.select { |hash| ["Payment to service providers (Doctor, X-ray, Laboratory)", "Refund to Employers", "Insurance payment to Fomema Global Sdn Bhd"].include?(hash[:task]) },
      medical_review: @task_list.select { |hash| ["Appeal cases", "Pending Review Cases", "TCUPI Cases", "Employer Enquiry JIVO"].include?(hash[:task]) },
      regional_office: @task_list.select do |hash|
        ["Change of employer (transfer)", "Amendment of Foreign worker info","Update employer details", "Employer Registration Approval"].include?(hash[:task]) ||
          (hash[:task] == 'Special Renewal Approval (unfit)' && hash[:TAT] == '3wd')
      end,
      human_capital: @task_list.select { |hash| ["Staff Claims Submission"].include?(hash[:task]) },
      management: @task_list.select { |hash| ["Approval for registration of service provider", "Activating new service provider"].include?(hash[:task]) }
    }
  end

  def tasks
    @params ||= {}
    [
      {
        KPI: 0, # yet to be discussed
        task: 'Email',
        TAT: 'First response time within 24 business hours',
        target: '80%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Chat',
        TAT: 'First response time within 24 business hours ',
        target: '80%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Bypass fingerprint approval',
        TAT: '24 business hours',
        target: '80%'
      },
      {
        KPI: kpi_percentage("Employer", 2),
        task: 'Employer Registration',
        TAT: '2wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("Agency", 14),
        task: 'Agency Registration',
        TAT: '14wd',
        target: '80%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Foreign Worker Amendment',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("FwChangeEmployer", 3),
        task: 'Change Employer (transfer worker)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 2),
        task: 'Special Renewal Approval (unfit)',
        TAT: '2wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Update Employer Detail Approval (Employer)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: review_xray,
        task: 'Review - Normal chest X-ray',
        TAT: '72 hours from the date of certification',
        target: '80%'
      },
      {
        KPI: pcr_xray,
        task: 'Audit - Abnormal chest X-ray',
        TAT: '48 hours from the date of certification',
        target: '80%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'XQCC Amendment',
        TAT: 'Four (4) weeks from the date of confirmation',
        target: '80%'
      },
      {
        KPI: kpi_percentage("Laboratory", nil),
        task: 'Laboratory',
        TAT: 'Calendar year',
        target: '100%'
      },
      {
        KPI: kpi_percentage("DoctorVisit", nil),
        task: 'Doctor Visit',
        TAT: 'Calendar year',
        target: '100%'
      },
      {
        KPI: kpi_percentage("XrayFacility", nil),
        task: 'X-ray Visit',
        TAT: 'Calendar year',
        target: '100%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Payment to service providers (Doctor, X-ray, Laboratory)',
        TAT: 'For every 7 working days, Finance team will generate data from Nios and transmit those data to Sage, our accounting system, to perform the payment processes.\n\nThe payments will be generated into 5 batches based on the certification dates:\n\na) 1st - 6th\nb) 7th - 12th\nc) 13th -18th\nd) 19th -24th\ne) 25th -30th',
        target: '100%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Refund to Employers',
        TAT: '80%',
        target: ''
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Insurance payment to Fomema Global Sdn Bhd',
        TAT: '100%',
        target: '80%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Appeal cases',
        TAT: '28wd',
        target: '90%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Pending Review Cases',
        TAT: '3wd',
        target: '90%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'TCUPI Cases',
        TAT: '28wd',
        target: '90%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Employer Enquiry JIVO',
        TAT: '24 hours',
        target: '100%'
      },
      {
        KPI: kpi_percentage("FwChangeEmployer", 3),
        task: 'Change of employer (transfer)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Amendment of Foreign worker info',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Special Renewal Approval (unfit)',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Update employer details',
        TAT: '3wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalRequest", 3),
        task: 'Employer Registration Approval',
        TAT: '2wd',
        target: '80%'
      },
      {
        KPI: 0, # yet to be discussed
        task: 'Staff Claims Submission',
        TAT: 'One Week from date HODs approved to HCM verification',
        target: '90%'
      },
      {
        KPI: kpi_percentage("ApprovalandActivation", 14),
        task: 'Approval for registration of service provider',
        TAT: '14wd',
        target: '80%'
      },
      {
        KPI: kpi_percentage("ApprovalandActivation", 10),
        task: 'Activating new service provider',
        TAT: '10wd',
        target: '80%'
      }
    ]
  end

  def kpi_percentage(model_name, tat)
    achieved_count = 0
    achieved_count = 0
    not_achieved_count = 0
    total_count = 0

    if params[:dateRange].present?
      start_date, end_date = params[:dateRange].split(" - ").map { |date| Date.strptime(date, "%d/%m/%Y") }
    else
      start_date = @beginning_of_year
      end_date = @end_of_year
    end

    case model_name
    when "Employer"
      achieved_count = Employer.where("created_at <= registration_approved_at + interval '? days'", tat).count
      not_achieved_count = Employer.where("created_at > registration_approved_at + interval '? days'", tat).count

    when "Agencies"
      achieved_count = Agency.where("created_at <= registration_approved_at + interval '? days'", tat).count
      not_achieved_count = Agency.where("created_at > registration_approved_at + interval '? days'", tat).count

    when "ApprovalRequest"
      #achieved_count = ApprovalRequest.where("approved_at <= requested_at + interval '? days'", tat.to_i).count
      #not_achieved_count = ApprovalRequest.where("approved_at > requested_at + interval '? days'", tat.to_i).count

    when "FwChangeEmployer"
      achieved_count = FwChangeEmployer.where("approval_at <= requested_at + interval '? days'", tat).count
      not_achieved_count = FwChangeEmployer.where("approval_at > requested_at + interval '? days'", tat).count

    when "Laboratory"
      total_active = Laboratory.where(status: 'ACTIVE').count
      total_visit = VisitReport.where(visit_date: start_date..end_date).count

    when "DoctorVisit"
      total_active = Doctor.where(status: 'ACTIVE').count
      total_visit = VisitReport.where(visit_date: start_date..end_date).count

    when "XrayFacility"
      total_active = XrayFacility.where(status: 'ACTIVE').count
      total_visit = VisitReport.where(visit_date: start_date..end_date).count

    when "ApprovalandActivation"
      doctor_achieved = Doctor.where("registration_approved_at <= created_at + interval '? days'", tat).count
      doctor_not_achieved = Doctor.where("registration_approved_at > created_at + interval '? days'", tat).count
      xray_achieved = XrayFacility.where("registration_approved_at <= created_at + interval '? days'", tat).count
      xray_not_achieved = XrayFacility.where("registration_approved_at > created_at + interval '? days'", tat).count
      lab_achived = Laboratory.where("registration_approved_at <= created_at + interval '? days'", tat).count
      lab_not_achieved = Laboratory.where("registration_approved_at > created_at + interval '? days'", tat).count
      achieved_count = doctor_achieved + xray_achieved + lab_achived
      not_achieved_count = doctor_not_achieved + xray_not_achieved + lab_not_achieved
    end

    if model_name == "Laboratory" || model_name == "DoctorVisit" || model_name == "XrayFacility"
      achieved_count = total_visit
      total_count = total_active
    else
      total_count = achieved_count + not_achieved_count
    end

    kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0
    kpi_percentage.round(1) # Round to one decimal place
  end

  def review_xray
    achieved_count = 0
    not_achieved_count = 0

    if params[:dateRange].present?
      start_date, end_date = params[:dateRange].split(" - ").map { |date| Date.strptime(date, "%d/%m/%Y") }
    else
      start_date = @beginning_of_year
      end_date = @end_of_year
    end

    # achieved_count = Transaction.joins("INNER JOIN xray_reviews ON xray_reviews.id = transactions.xray_review_id")
    #                             .where("xray_reviews.transmitted_at <= transactions.certification_date + INTERVAL '3' DAY")
    #                             .where(transactions: { transaction_date: start_date..end_date })
    #                             .count
    #
    # not_achieved_count = Transaction.joins("INNER JOIN xray_reviews ON xray_reviews.id = transactions.xray_review_id")
    #                                 .where("xray_reviews.transmitted_at > transactions.certification_date + INTERVAL '3' DAY")
    #                                 .where(transactions: { transaction_date: start_date..end_date })
    #                                 .count

    total_count = achieved_count + not_achieved_count
    kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0
    kpi_percentage.round(1) # Round to one decimal place

  end

  def pcr_xray
    achieved_count = 0
    not_achieved_count = 0

    if params[:dateRange].present?
      start_date, end_date = params[:dateRange].split(" - ").map { |date| Date.strptime(date, "%d/%m/%Y") }
    else
      start_date = @beginning_of_year
      end_date = @end_of_year
    end

    achieved_count = PcrReview.joins("INNER JOIN transactions ON transactions.pcr_review_id = pcr_reviews.id")
                              .where("pcr_reviews.transmitted_at <= (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'")
                              .where(transactions: { transaction_date: start_date..end_date })
                              .count

    not_achieved_count = PcrReview.joins("INNER JOIN transactions ON transactions.pcr_review_id = pcr_reviews.id")
                                  .where("pcr_reviews.transmitted_at > (transactions.certification_date + INTERVAL '2 days') AT TIME ZONE 'UTC'")
                                  .where(transactions: { transaction_date: start_date..end_date })
                                  .count

    total_count = achieved_count + not_achieved_count
    kpi_percentage = total_count > 0 ? (achieved_count.to_f / total_count) * 100 : 0
    kpi_percentage.round(1)

  end

  def filter_params(query = {}, records = 0)
    records = records
    query.each do |key, value|
      case key
      when "dateRange"
        start_date, end_date = value.split(" - ").map { |date| Date.strptime(date, "%d/%m/%Y") }
        records = records.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      when "month"
        unless value == "Select Monthly"
          current_year = Date.today.year
          selected_month = Date::MONTHNAMES.index(value.split(" ").last)
          records = records.where("EXTRACT(MONTH FROM created_at) = ? AND EXTRACT(YEAR FROM created_at) = ?", selected_month, current_year)
        end
        # when "week"
        #   unless value == "Select Week"
        #     selected_week = value.split(" ").last.to_i
        #     records = records.where("EXTRACT(WEEK FROM created_at) = ?", selected_week)
        #   end
      end
    end
    records
  end
end