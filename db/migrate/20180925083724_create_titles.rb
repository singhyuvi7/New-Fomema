class CreateTitles < ActiveRecord::Migration[5.2]
  def change
    create_table :titles do |t|
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
