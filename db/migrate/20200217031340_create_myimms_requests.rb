class CreateMyimmsRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :myimms_requests do |t|

      t.string :batch_code
      t.integer :batch_count
      t.text :batch_list, limit: 16.megabytes - 1

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
