class AddMaidOnlineToForeignWorkers < ActiveRecord::Migration[6.0]
  def change
    add_column :foreign_workers, :maid_online, :string, default: "FOMEMA"
    add_index :foreign_workers, :maid_online
  end
end
