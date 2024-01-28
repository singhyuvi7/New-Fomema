class CreateTransactionVerifyDocs < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_verify_docs do |t|
      t.bigint :transaction_id, index: true
      t.text :category
      t.bigint :submitted_by, index: true
      t.datetime :submitted_at
      t.bigint :approval_by, index: true
      t.datetime :approval_at
      t.string :decision
      t.string :status, index: true
      t.text :approval_comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
