class CreateFpxResponseCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :fpx_response_codes do |t|
      t.string :code, index: true
      t.string :name
      t.timestamps
      t.bigint :created_by
      t.bigint :updated_by
    end
  end
end
