class AddForeignWorkersMonitoringFields < ActiveRecord::Migration[6.0]
  def change
    add_column :foreign_workers, :monitor_reason_id, :bigint, index: true
    add_column :foreign_workers, :monitor_comment, :text
    add_column :foreign_workers, :unmonitor_comment, :text
  end
end
