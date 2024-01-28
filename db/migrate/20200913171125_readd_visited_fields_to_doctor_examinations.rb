class ReaddVisitedFieldsToDoctorExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :doctor_examinations, :visited_history_1, :boolean
        add_column :doctor_examinations, :visited_history_2, :boolean
        add_column :doctor_examinations, :visited_physical, :boolean
        add_column :doctor_examinations, :visited_system_1, :boolean
        add_column :doctor_examinations, :visited_system_2, :boolean
        add_column :doctor_examinations, :visited_laboratory_result, :boolean
        add_column :doctor_examinations, :visited_xray_facility_result, :boolean
        add_column :doctor_examinations, :visited_condition, :boolean
        add_column :doctor_examinations, :visited_certification, :boolean
        add_column :doctor_examinations, :visited_follow_up, :boolean
    end
end