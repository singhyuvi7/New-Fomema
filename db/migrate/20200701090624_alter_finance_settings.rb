class AlterFinanceSettings < ActiveRecord::Migration[6.0]
  def change
    rename_column :finance_settings, :gl_code, :value
    remove_column :finance_settings, :bank_code
  end
end
