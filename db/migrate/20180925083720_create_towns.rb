class CreateTowns < ActiveRecord::Migration[5.2]
  def change
    create_table :towns do |t|
      t.string :code, index: true
      t.string :name
      t.belongs_to :state
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
