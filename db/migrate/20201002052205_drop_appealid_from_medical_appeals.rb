class DropAppealidFromMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        remove_column :medical_appeals, :appealid
    end
end
