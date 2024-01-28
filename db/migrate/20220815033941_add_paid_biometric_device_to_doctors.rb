class AddPaidBiometricDeviceToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :paid_biometric_device, :boolean
  end
end
