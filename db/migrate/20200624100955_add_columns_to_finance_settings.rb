class AddColumnsToFinanceSettings < ActiveRecord::Migration[6.0]
  def change
    remove_column :finance_settings, :version
    remove_column :finance_settings, :value

    add_column :finance_settings, :type, :string
    add_column :finance_settings, :category, :string 
    add_column :finance_settings, :gl_code, :string 
    add_column :finance_settings, :bank_number, :string 
  end
end
