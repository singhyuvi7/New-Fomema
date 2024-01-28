class AddMonitoringToForeignWorker < ActiveRecord::Migration[6.0]
  def change
    add_column :foreign_workers, :monitoring, :string, default: 'N'
    add_index :foreign_workers, :monitoring
  end
end
