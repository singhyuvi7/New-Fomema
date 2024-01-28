class CreateFwChangeEmployers < ActiveRecord::Migration[6.0]
  def change
    create_table :fw_change_employers do |t|
      t.bigint :foreign_worker_id, index: true
      t.bigint :customerable_id
      t.string :customerable_type
      t.bigint :old_employer_id
      t.bigint :new_employer_id
      t.string :fw_name
      t.string :fw_passport_number
      t.integer :fw_country_id
      t.string :fw_gender
      t.date :fw_date_of_birth
      t.bigint :requested_by, index: true
      t.datetime :requested_at
      t.bigint :approval_by, index: true
      t.datetime :approval_at
      t.string :decision
      t.string :status, index: true
      t.text :approval_comment
      t.text :comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :assigned_to, index: true
    end
    
    add_index :fw_change_employers, [:customerable_id, :customerable_type], name: 'change_employer_customerable'
  end
end
