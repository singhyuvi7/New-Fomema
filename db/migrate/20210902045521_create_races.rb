class CreateRaces < ActiveRecord::Migration[6.0]
  def change
    create_table :races do |t|
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
