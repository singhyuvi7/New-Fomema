class CreateAmendmentReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :amendment_reasons do |t|
      t.string :code, index: true
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
