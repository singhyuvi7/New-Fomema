class CreateForeignWorkerAmendmentReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :foreign_worker_amendment_reasons do |t|
      t.belongs_to :foreign_worker
      t.belongs_to :amendment_reason

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    remove_column :foreign_workers, :amendment_reason_id, :bigint
    add_column :foreign_workers, :amendment_reasons, :json
  end
end
