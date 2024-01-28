class CreateDigitalXrayProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :digital_xray_providers do |t|
      t.string :code
      t.string :name
      t.string :passphrase
      t.string :provider_url
      t.timestamps
    end
  end
end
