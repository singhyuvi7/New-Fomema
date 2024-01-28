class CreateTransactionCarts < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_carts do |t|
            t.belongs_to :foreign_worker, index: true
            t.timestamps
            t.bigint :created_by, index: true
            t.bigint :updated_by, index: true
        end

        add_index :transaction_carts, [:foreign_worker_id, :created_by], unique: true
    end
end
