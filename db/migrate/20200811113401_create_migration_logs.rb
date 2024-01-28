class CreateMigrationLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :migration_logs do |t|
      t.string :description
      t.text :comment
      t.datetime :start_at
      t.datetime :end_at
    end
  end
end
