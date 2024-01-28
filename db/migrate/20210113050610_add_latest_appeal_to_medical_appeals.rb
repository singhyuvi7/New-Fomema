class AddLatestAppealToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :latest_appeal, :boolean, default: true
        add_index :medical_appeals, :latest_appeal
    end
end