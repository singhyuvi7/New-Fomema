class CreateStatusSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :status_schedules do |t|
      t.references :status_scheduleable, polymorphic: true, index: { name: "index_vr_status_schedules_on_status_scheduleable" }
      t.date :from, index: true
      t.date :to, index: true
      t.string :status
      t.string :status_reason
      t.text :comment
      t.string :previous_status
      t.string :previous_status_reason
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
