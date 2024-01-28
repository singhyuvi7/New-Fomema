class DropMvFirstTransactions < ActiveRecord::Migration[6.0]
    def up
        execute "drop materialized view if exists mv_first_transactions"
    end
end