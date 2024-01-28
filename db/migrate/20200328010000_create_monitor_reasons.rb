class CreateMonitorReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :monitor_reasons do |t|
      t.string :code, index: true
      t.string :description
      t.string :short_description
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
