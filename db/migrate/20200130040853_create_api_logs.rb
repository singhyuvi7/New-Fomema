class CreateApiLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :api_logs do |t|
      t.string :name
      t.string :api_type
      t.string :request_type
      t.string :method
      t.string :url
      t.json :params
      t.json :headers
      t.json :body
      t.json :response
      t.text :full_response
      t.bigint :requested_by, index: true
      t.timestamps
    end
  end
end
