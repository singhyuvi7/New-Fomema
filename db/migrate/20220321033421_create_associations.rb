class CreateAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :associations do |t|
      t.string :code, index: true
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
