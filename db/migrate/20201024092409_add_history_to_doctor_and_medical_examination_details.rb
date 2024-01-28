class AddHistoryToDoctorAndMedicalExaminationDetails < ActiveRecord::Migration[6.0]
    def change
        add_column :doctor_examination_details, :history, :boolean
        add_column :medical_examination_details, :history, :boolean
    end
end