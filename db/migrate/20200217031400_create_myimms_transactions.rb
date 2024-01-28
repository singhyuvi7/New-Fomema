class CreateMyimmsTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :myimms_transactions do |t|

      t.belongs_to :transaction
      t.string :status

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
