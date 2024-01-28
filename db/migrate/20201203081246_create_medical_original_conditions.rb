class CreateMedicalOriginalConditions < ActiveRecord::Migration[6.0]
    def change
        create_table :medical_original_conditions do |t|
            t.bigint    :medical_examination_id
            t.jsonb     :original_params
            t.timestamps
        end

        add_index :medical_original_conditions, :medical_examination_id
    end
end