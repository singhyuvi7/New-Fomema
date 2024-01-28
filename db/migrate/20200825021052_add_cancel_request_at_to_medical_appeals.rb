class AddCancelRequestAtToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :cancel_request_at, :datetime
        add_index :medical_appeals, :cancel_request_at
    end
end