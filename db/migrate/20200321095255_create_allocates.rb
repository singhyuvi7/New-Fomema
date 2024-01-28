class CreateAllocates < ActiveRecord::Migration[6.0]
  def change
    create_table :allocates do |t|
      t.belongs_to :doctor
      t.bigint :old_allocatable_id
      t.string :old_allocatable_type

      t.bigint :new_allocatable_id
      t.string :new_allocatable_type

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
