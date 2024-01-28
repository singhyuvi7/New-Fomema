class DropFirstTransactionsTable < ActiveRecord::Migration[6.0]
    def up
        execute "drop table if exists first_transactions"
    end
end