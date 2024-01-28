class CreateMedicalAppealConditions < ActiveRecord::Migration[6.0]
    def change
        create_table :medical_appeal_conditions do |t|
            t.bigint    :transaction_id
            t.integer   :condition_id
            t.bigint    :medical_appeal_id
            t.bigint    :created_by
            t.bigint    :updated_by
            t.datetime  :deleted_at
            t.timestamps
        end

        add_index :medical_appeal_conditions, :transaction_id
        add_index :medical_appeal_conditions, :condition_id
        add_index :medical_appeal_conditions, :medical_appeal_id
    end
end