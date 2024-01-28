class CreateXqccTransactionComments < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_transaction_comments do |t|
            t.bigint :transaction_id, index: true
            t.text :comment
            t.string :source
            t.string :category
            t.timestamps
            t.bigint :created_by, index: true
            t.bigint :updated_by
        end
    end
end
