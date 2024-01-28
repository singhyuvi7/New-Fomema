class AddRadiologistIdToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :radiologist_id, :integer
        add_index :medical_appeals, :radiologist_id
    end
end
