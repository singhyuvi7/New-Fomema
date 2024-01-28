class AddRegistrationTypeToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :registration_type, :integer, default: 0, null: false
  end
end
