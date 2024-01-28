class AddBankDetailsToFinanceSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :finance_settings, :bank_code, :string
  end
end
