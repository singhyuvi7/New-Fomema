module Internal::DashboardsSettings
  class CustomerSurveyUploadController < InternalController
    def customer_satisfaction
      file = params[:file]

      begin
        file_name = File.basename(file.original_filename)
        file_ext = File.extname(file.original_filename)
        allowed_extensions = [".xlsx", ".csv"]
        raise "Unknown file type: #{file.original_filename}" unless allowed_extensions.include?(file_ext.downcase)

        if file_ext.downcase == ".xlsx"
          process_xlsx(file, file_name)
        elsif file_ext.downcase == ".csv"
          process_csv(file, file_name)
        else
          raise "Unsupported file type: #{file.original_filename}"
        end

        flash[:notice] = "Records Imported"
      rescue StandardError => e
        flash[:notice] = "Issues with file: #{e.message}"
      end

      render 'internal/dashboards_settings/index'
    end

    def process_xlsx(file, file_name)
      creek = Creek::Book.new(file.path)
      sheet = creek.sheets[0]
      sheet.rows.each_with_index do |row, i|
        next if i == 0 # Skip the header row

        row_data = {
          "respondent_id" => row["A"],
          "collector_id" => row["B"],
          "start_date" => row["C"],
          "end_date" => row["D"],
          "ip_address" => row["E"],
          "email_address" => row["F"],
          "first_name" => row["G"],
          "custom_data" => "",
          "what_is_your_email_address" => "",
          "what_is_your_gender" => row["H"],
          "what_is_your_age" => row["I"],
          "what_is_customer_suits_you" => row["J"],
          "which_sector_below_represents" => row["K"],
          "where_did_you_register_your_worker" => row["L"],
          "process_emp_reg" => row["M"],
          "process_worker_reg" => row["N"],
          "panel_clinic_xray_facilities" => row["O"],
          "overall_experience_reg_process" => row["P"],
          "other" => row["T"],
          "location_panel_clinics" => row["R"],
          "Fomema_medical_examincation_are_understandable" => row["S"],
          "medical_Examinations_are_easy_toobtain" => row["T"],
          "Overall_rate_experience_medical_examination" => row["U"],
          "Other_medical" => row["V"],
          "worker_status_found_medical_unsuitable" => row["W"],
          "undergo_fomema_appeal_process" => row["X"],
          "tell_experience_appeal_process" => row["Y"],
          "other_appealprocess" => row["Z"],
          "recommend_fomema_friend_collegue" => row["AA"],
          "announcement_business_operator" => row["AB"],
          "delivering_health" => row["AC"],
          "aligned_info_moh_MOHA" => row["AD"],
          "facebook" => row["AE"],
          "twitter" => row["AF"],
          "instagram" => row["AG"],
          "telegram" => row["AH"],
          "other_social" => row["AI"],
          "what_tochange_fomema_socialmedia" => row["AJ"],
          "how_do_you_reachus" => row["AK"],
          "how_long_did_you_wait" => row["AL"],
          "is_this_issue_or_problem" => row["AM"],
          "how_would_you_rate" => row["AN"],
          "overall_how_satisfied_are_you" => row["AO"]
        }

        SurveyMonkeyCustomer.create(
          row_data.merge(file_name: file_name)
        )
      end
    end

    def process_csv(file, file_name)
      csv_data = CSV.read(file.path, headers: true)
      header = csv_data.headers
      (0..csv_data.length - 1).each do |i|
        row = Hash[header.zip(csv_data[i])]
        rrow_data = {
          "respondent_id" => row["respondent_id"],
          "collector_id" => row["collector_id"],
          "start_date" => row["start_date"],
          "end_date" => row["end_date"],
          "ip_address" => row["ip_address"],
          "email_address" => row["email_address"],
          "first_name" => row["first_name"],
          "custom_data" => "",
          "what_is_your_email_address" => "",
          "what_is_your_gender" => row["what_is_your_gender"],
          "what_is_your_age" => row["what_is_your_age"],
          "what_is_customer_suits_you" => row["what_is_customer_suits_you"],
          "which_sector_below_represents" => row["which_sector_below_represents"],
          "where_did_you_register_your_worker" => row["where_did_you_register_your_worker"],
          "process_emp_reg" => row["process_emp_reg"],
          "process_worker_reg" => row["process_worker_reg"],
          "panel_clinic_xray_facilities" => row["panel_clinic_xray_facilities"],
          "overall_experience_reg_process" => row["overall_experience_reg_process"],
          "other" => row["other"],
          "location_panel_clinics" => row["location_panel_clinics"],
          "Fomema_medical_examincation_are_understandable" => row["Fomema_medical_examincation_are_understandable"],
          "medical_Examinations_are_easy_toobtain" => row["medical_Examinations_are_easy_toobtain"],
          "Overall_rate_experience_medical_examination" => row["Overall_rate_experience_medical_examination"],
          "Other_medical" => row["Other_medical"],
          "worker_status_found_medical_unsuitable" => row["worker_status_found_medical_unsuitable"],
          "undergo_fomema_appeal_process" => row["undergo_fomema_appeal_process"],
          "tell_experience_appeal_process" => row["tell_experience_appeal_process"],
          "other_appealprocess" => row["other_appealprocess"],
          "recommend_fomema_friend_collegue" => row["recommend_fomema_friend_collegue"],
          "announcement_business_operator" => row["announcement_business_operator"],
          "delivering_health" => row["delivering_health"],
          "aligned_info_moh_MOHA" => row["aligned_info_moh_MOHA"],
          "facebook" => row["facebook"],
          "twitter" => row["twitter"],
          "instagram" => row["instagram"],
          "telegram" => row["telegram"],
          "other_social" => row["other_social"],
          "what_tochange_fomema_socialmedia" => row["what_tochange_fomema_socialmedia"],
          "how_do_you_reachus" => row["how_do_you_reachus"],
          "how_long_did_you_wait" => row["how_long_did_you_wait"],
          "is_this_issue_or_problem" => row["is_this_issue_or_problem"],
          "how_would_you_rate" => row["how_would_you_rate"],
          "overall_how_satisfied_are_you" => row["overall_how_satisfied_are_you"]
        }

        SurveyMonkeyCustomer.create(
          row_data.merge(file_name: file_name)
        )
      end
    end
  end
end
