class CreateFinBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :fin_batches do |t|

      t.string :code, index: {unique: true}
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
