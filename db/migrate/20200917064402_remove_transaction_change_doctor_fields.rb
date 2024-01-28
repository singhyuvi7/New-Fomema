class RemoveTransactionChangeDoctorFields < ActiveRecord::Migration[6.0]
    def change
        remove_column :transactions, :change_doctor_reason_id, :bigint
        remove_column :transactions, :doctor_changed_by, :bigint
        remove_column :transactions, :doctor_changed_at, :datetime
        remove_column :transactions, :change_doctor_reason_comment, :text
    end
end
