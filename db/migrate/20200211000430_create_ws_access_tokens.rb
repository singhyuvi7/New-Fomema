class CreateWsAccessTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :ws_access_tokens do |t|
      t.string :usercode, index: true
      t.string :token, index: true
      t.datetime :last_access
      t.datetime :expired_at
      t.timestamps
    end
  end
end
