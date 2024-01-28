class CreateFees < ActiveRecord::Migration[5.2]
  def change
    create_table :fees do |t|
      t.string :code
      t.string :name
      t.string :remark
      t.decimal :amount, default: 0
      t.string :status

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.datetime :deleted_at
    end
    add_index :fees, :code, unique: true
  end
end
