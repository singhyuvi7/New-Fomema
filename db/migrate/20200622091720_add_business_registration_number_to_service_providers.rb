class AddBusinessRegistrationNumberToServiceProviders < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :business_registration_number, :string
    add_column :xray_facilities, :business_registration_number, :string
  end
end
