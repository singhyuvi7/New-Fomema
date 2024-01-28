class CreateSurveyMonkeyCustomers < ActiveRecord::Migration[6.0]
    def change
      create_table :survey_monkey_customers do |t|
        t.string :respondent_id
        t.string :collector_id
        t.datetime :start_date
        t.datetime :end_date
        t.string :ip_address
        t.string :email_address
        t.string :first_name
        t.string :last_name
        t.string :custom_data
        t.string :what_is_your_email_address
        t.string :what_is_your_gender
        t.string :what_is_your_age
        t.string :what_is_customer_suits_you
        t.string :which_sector_below_represents
        t.string :where_did_you_register_your_worker
        t.string :process_emp_reg
        t.string :process_worker_reg
        t.string :panel_clinic_xray_facilities
        t.string :overall_experience_reg_process
        t.string :other
        t.string :location_panel_clinics
        t.string :fomema_medical_examination_are_understandable
        t.string :medical_examinations_are_easy_to_obtain
        t.string :overall_rate_experience_medical_examination
        t.string :other_medical
        t.string :worker_status_found_medical_unsuitable
        t.string :undergo_fomema_appeal_process
        t.string :tell_experience_appeal_process
        t.string :other_appeal_process
        t.string :recommend_fomema_friend_collegue
        t.string :announcement_business_operator
        t.string :delivering_health
        t.string :aligned_info_moh_MOHA
        t.string :facebook
        t.string :twitter
        t.string :instagram
        t.string :telegram
        t.string :other_social
        t.string :what_to_change_fomema_social_media
        t.string :how_do_you_reach_us
        t.string :how_long_did_you_wait
        t.string :is_this_issue_or_problem
        t.string :how_would_you_rate
        t.string :overall_how_satisfied_are_you         
        t.timestamps
      end
    end
  end
  