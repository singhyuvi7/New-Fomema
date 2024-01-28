class CreateForeignWorkerChanges < ActiveRecord::Migration[6.0]
    def change
        create_table :foreign_worker_changes do |t|
            t.bigint :foreign_worker_id, index: true
            t.timestamps
            t.bigint :created_by
            t.string :field
            t.string :old_value
            t.string :new_value
        end
    end
end
