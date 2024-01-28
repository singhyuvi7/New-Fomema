module Internal::DashboardsSettings
    class CustomerSurveyUploadController < InternalController
      def customer_satisfaction
        file = params[:file]
  
        begin
          file_name = File.basename(file.original_filename)
          file_ext = File.extname(file.original_filename)
          allowed_extensions = [".csv", ".xls", ".xlsx"]
          raise "Unknown file type: #{file.original_filename}" unless allowed_extensions.include?(file_ext.downcase)
  
          spreadsheet = case file_ext.downcase
                        when ".xls"
                          Roo::Excel.new(file.path)
                        when ".xlsx"
                          Roo::Excelx.new(file.path)
                        when ".csv"
                          CSV.read(file.path)
                        end
  
          if spreadsheet.is_a?(Roo::Base) || spreadsheet.is_a?(CSV::Table)
            (2..spreadsheet.last_row).each do |i|
              row_data = {
                "respondent_id" => spreadsheet.row(i)[0],
                "collector_id" => spreadsheet.row(i)[1],
                "start_date" => spreadsheet.row(i)[2],
                "end_date" => spreadsheet.row(i)[3],
                "ip_address" => spreadsheet.row(i)[4],
                "email_address" => spreadsheet.row(i)[5],
                "first_name" => spreadsheet.row(i)[6],
                "custom_data" => "",
                "what_is_your_email_address" => "",
                "what_is_your_gender" => spreadsheet.row(i)[8],
                "what_is_your_age" => spreadsheet.row(i)[9],
                "what_is_customer_suits_you" => spreadsheet.row(i)[10],
                "which_sector_below_represents" => spreadsheet.row(i)[11],
                "where_did_you_register_your_worker" => spreadsheet.row(i)[12],
                "process_emp_reg" => spreadsheet.row(i)[13],
                "process_worker_reg" => spreadsheet.row(i)[14],
                "panel_clinic_xray_facilities" => spreadsheet.row(i)[15],
                "overall_experience_reg_process" => spreadsheet.row(i)[16],
                "other" => spreadsheet.row(i)[19],
                "location_panel_clinics" => spreadsheet.row(i)[17],
                "fomema_medical_examination_are_understandable" => spreadsheet.row(i)[18],
                "medical_examinations_are_easy_to_obtain" => spreadsheet.row(i)[19],
                "overall_rate_experience_medical_examination" => spreadsheet.row(i)[20],
                "other_medical" => spreadsheet.row(i)[21],
                "worker_status_found_medical_unsuitable" => spreadsheet.row(i)[22],
                "undergo_fomema_appeal_process" => spreadsheet.row(i)[23],
                "tell_experience_appeal_process" => spreadsheet.row(i)[24],
                "other_appeal_process" => spreadsheet.row(i)[25],
                "recommend_fomema_friend_collegue" => spreadsheet.row(i)[26],
                "announcement_business_operator" => spreadsheet.row(i)[27],
                "delivering_health" => spreadsheet.row(i)[28],
                "aligned_info_moh_MOHA" => spreadsheet.row(i)[29],
                "facebook" => spreadsheet.row(i)[30],
                "twitter" => spreadsheet.row(i)[31],
                "instagram" => spreadsheet.row(i)[32],
                "telegram" => spreadsheet.row(i)[33],
                "other_social" => spreadsheet.row(i)[34],
                "what_to_change_fomema_social_media" => spreadsheet.row(i)[35],
                "how_do_you_reach_us" => spreadsheet.row(i)[36],
                "how_long_did_you_wait" => spreadsheet.row(i)[37],
                "is_this_issue_or_problem" => spreadsheet.row(i)[38],
                "how_would_you_rate" => spreadsheet.row(i)[39],
                "overall_how_satisfied_are_you" => spreadsheet.row(i)[40]
              }
  
              SurveyMonkeyCustomer.create(
                row_data.merge(file_name: file_name)
              )
  
            end
          end
  
          flash[:notice] = "Records Imported"
        rescue StandardError => e
          flash[:notice] = "Issues with file: #{e.message}"
        end
  
        # redirect_to settings_customer_survey_upload_path, notice: 'Products imported.'
        render 'internal/dashboards_settings/index'
      end
    end
  end