class AddDigitalXrayProviderToXrays < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_appeal_retakes, :digital_xray_provider_id, :integer
        add_index :xray_appeal_retakes, :digital_xray_provider_id
        add_column :xray_examination_retakes, :digital_xray_provider_id, :integer
        add_index :xray_examination_retakes, :digital_xray_provider_id
    end
end