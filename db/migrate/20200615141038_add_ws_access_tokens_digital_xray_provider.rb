class AddWsAccessTokensDigitalXrayProvider < ActiveRecord::Migration[6.0]
  def change
    add_column :ws_access_tokens, :digital_xray_provider_code, :string, index: true
  end
end
