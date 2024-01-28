class CreateEmployerTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :employer_types do |t|
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
