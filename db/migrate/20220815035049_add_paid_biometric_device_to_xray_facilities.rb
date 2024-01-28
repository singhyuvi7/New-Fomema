class AddPaidBiometricDeviceToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_facilities, :paid_biometric_device, :boolean
  end
end