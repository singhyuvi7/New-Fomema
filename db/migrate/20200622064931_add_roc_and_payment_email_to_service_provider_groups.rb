class AddRocAndPaymentEmailToServiceProviderGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :service_provider_groups, :business_registration_number, :string
    add_column :service_provider_groups, :email_payment, :string
  end
end
