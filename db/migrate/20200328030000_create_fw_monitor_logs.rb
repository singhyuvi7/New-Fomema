class CreateFwMonitorLogs < ActiveRecord::Migration[6.0]
  def change
        create_table :fw_monitor_logs do |t|
            t.belongs_to :foreign_worker, index: true
            t.belongs_to :monitor_reason, index: true
            t.text :monitor_comment
            t.bigint :monitor_request_by, index: true
            t.datetime :monitor_request_at, index: true
            t.text :unmonitor_comment
            t.bigint :unmonitor_request_by, index: true
            t.datetime :unmonitor_request_at, index: true

            t.timestamps
            t.bigint :created_by, index: true
            t.bigint :updated_by, index: true
        end
    end
end
