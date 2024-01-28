class CreateFwAmendmentDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :fw_amendment_details do |t|
            t.bigint :fw_amendment_id, index: true
            t.string :field
            t.string :old_value
            t.string :new_value
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end
    end
end
