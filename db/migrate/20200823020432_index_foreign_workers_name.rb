class IndexForeignWorkersName < ActiveRecord::Migration[6.0]
  def up
    execute "create extension if not exists pg_trgm"
    remove_index :foreign_workers, :name
    execute "create index index_foreign_workers_on_name on foreign_workers using gin (name gin_trgm_ops)"
  end

  def down
    execute "drop index if exists index_foreign_workers_on_name"
    add_index :foreign_workers, :name
  end
end
