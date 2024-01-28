class AddLatestInsurancePurchaseIdToForeignWorkers < ActiveRecord::Migration[6.0]
  def change
    add_column :foreign_workers, :latest_insurance_purchase_id, :bigint
    add_index :foreign_workers, :latest_insurance_purchase_id
  end
end
