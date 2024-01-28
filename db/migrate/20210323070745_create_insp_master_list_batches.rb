class CreateInspMasterListBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :insp_master_list_batches do |t|
      t.datetime :start_date, index: true
      t.datetime :end_date, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
