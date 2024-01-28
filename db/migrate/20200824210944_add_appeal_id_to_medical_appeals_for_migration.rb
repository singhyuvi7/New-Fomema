class AddAppealIdToMedicalAppealsForMigration < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :appealid, :integer
        add_index :medical_appeals, :appealid
    end
end
