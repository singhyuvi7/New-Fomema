class AddOrganizationIdVarious < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :organization_id, :bigint, index: true
    add_column :foreign_workers, :organization_id, :bigint, index: true
    add_column :transactions, :organization_id, :bigint, index: true
    add_column :bank_drafts, :organization_id, :bigint, index: true
    add_column :refunds, :organization_id, :bigint, index: true
  end
end
