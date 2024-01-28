class IndexTransactionsFwName < ActiveRecord::Migration[6.0]
  def up
    execute "create extension if not exists pg_trgm"
    remove_index :transactions, :fw_name
    execute "create index index_transactions_on_fw_name on transactions using gin (fw_name gin_trgm_ops)"
  end

  def down
    execute "drop index if exists index_transactions_on_fw_name"
    add_index :transactions, :fw_name
  end
end
