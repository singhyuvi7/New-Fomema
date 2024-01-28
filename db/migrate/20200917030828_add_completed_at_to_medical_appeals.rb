class AddCompletedAtToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :completed_at, :datetime
        add_index :medical_appeals, :completed_at
    end
end