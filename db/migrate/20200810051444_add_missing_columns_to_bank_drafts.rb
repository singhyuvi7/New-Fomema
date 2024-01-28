class AddMissingColumnsToBankDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :process_fee, :decimal, default: 0
    add_column :bank_drafts, :additional_fee_charge, :decimal, default: 0
    add_column :bank_drafts, :gst_amount, :decimal, default: 0
    add_column :bank_drafts, :gst_percentage, :decimal, default: 0
    add_column :bank_drafts, :additional_gst_charge, :decimal, default: 0
    add_column :bank_drafts, :comment, :text
  end
end