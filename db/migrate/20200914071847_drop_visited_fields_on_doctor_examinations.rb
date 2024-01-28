class DropVisitedFieldsOnDoctorExaminations < ActiveRecord::Migration[6.0]
    def change
        remove_column :doctor_examinations, :visited_history_1
        remove_column :doctor_examinations, :visited_history_2
        remove_column :doctor_examinations, :visited_physical
        remove_column :doctor_examinations, :visited_system_1
        remove_column :doctor_examinations, :visited_system_2
        remove_column :doctor_examinations, :visited_laboratory_result
        remove_column :doctor_examinations, :visited_xray_facility_result
        remove_column :doctor_examinations, :visited_condition
        remove_column :doctor_examinations, :visited_certification
        remove_column :doctor_examinations, :visited_follow_up
    end
end