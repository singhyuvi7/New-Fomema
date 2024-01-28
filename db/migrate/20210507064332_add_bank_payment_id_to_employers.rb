class AddBankPaymentIdToEmployers < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :bank_payment_id, :string
  end
end
