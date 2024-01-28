class CreateDoctorExaminationDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :doctor_examination_details do |t|
            t.bigint    :transaction_id
            t.integer   :condition_id
            t.bigint    :doctor_examination_id
            t.date      :date_value
            t.string    :text_value
            t.bigint    :created_by
            t.bigint    :updated_by
            t.datetime  :deleted_at
            t.timestamps
        end

        add_index :doctor_examination_details, :transaction_id
        add_index :doctor_examination_details, :condition_id
        add_index :doctor_examination_details, :doctor_examination_id
        add_index :doctor_examination_details, :deleted_at
    end
end