class CreateRetakeReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :retake_reasons do |t|
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
