class CreateSpGroupSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :sp_group_schedules do |t|
      t.bigint :sp_schedulable_id
      t.string :sp_schedulable_type
      t.belongs_to :service_provider_group, optional: true
      t.datetime :scheduled_date
  
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end