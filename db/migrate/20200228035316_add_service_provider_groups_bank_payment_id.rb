class AddServiceProviderGroupsBankPaymentId < ActiveRecord::Migration[6.0]
  def change
    add_column :service_provider_groups, :bank_payment_id, :string
  end
end
