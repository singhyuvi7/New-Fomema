class SpAddPaymentMethodId < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :payment_method_id, :bigint
    add_index :doctors, :payment_method_id
    add_column :laboratories, :payment_method_id, :bigint
    add_index :laboratories, :payment_method_id
    add_column :xray_facilities, :payment_method_id, :bigint
    add_index :xray_facilities, :payment_method_id
    add_column :service_provider_groups, :payment_method_id, :bigint
    add_index :service_provider_groups, :payment_method_id
  end
end
