class AddPaymentMethodToTransactionDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_details, :doc_payment_method_id, :bigint, index: true
    add_column :transaction_details, :lab_payment_method_id, :bigint, index: true
    add_column :transaction_details, :xray_payment_method_id, :bigint, index: true
    add_column :transaction_details, :doc_sp_group_payment_method_id, :bigint, index: true
    add_column :transaction_details, :lab_sp_group_payment_method_id, :bigint, index: true
    add_column :transaction_details, :xray_sp_group_payment_method_id, :bigint, index: true
  end
end
