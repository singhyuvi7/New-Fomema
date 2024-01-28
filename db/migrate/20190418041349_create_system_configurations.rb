class CreateSystemConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :system_configurations do |t|
      t.string :code, index: true
      t.string :name
      t.text :comment
      t.string :value
      t.string :new_value
      t.string :decision

      t.timestamps
      t.datetime :request_at
      t.datetime :approval_at
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :request_by, index: true
      t.bigint :approval_by, index: true
    end
  end
end
