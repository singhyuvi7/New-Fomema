class AddDigitalXrayProviderAuthor < ActiveRecord::Migration[6.0]
  def change
    add_column :digital_xray_providers, :created_by, :bigint, index: true
    add_column :digital_xray_providers, :updated_by, :bigint, index: true
  end
end
