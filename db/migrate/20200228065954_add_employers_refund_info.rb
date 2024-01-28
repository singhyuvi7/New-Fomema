class AddEmployersRefundInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :bank_id, :bigint
    add_index :employers, :bank_id
    add_column :employers, :bank_account_number, :string
  end
end
