class CreateMyimms < ActiveRecord::Migration[6.0]
  def change
    create_table :myimms do |t|
      t.string :batch_code

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
