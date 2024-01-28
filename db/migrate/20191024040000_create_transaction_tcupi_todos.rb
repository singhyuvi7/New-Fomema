class CreateTransactionTcupiTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_tcupi_todos do |t|
      t.belongs_to :transaction
      t.belongs_to :tcupi_todo
      t.boolean :done, default: false
      t.date :completed_date
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
