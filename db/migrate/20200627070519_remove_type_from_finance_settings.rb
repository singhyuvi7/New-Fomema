class RemoveTypeFromFinanceSettings < ActiveRecord::Migration[6.0]
  def change
    remove_column :finance_settings, :type
  end
end
