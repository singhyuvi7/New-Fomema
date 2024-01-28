class CreateDoctorExaminationComments < ActiveRecord::Migration[6.0]
    def change
        create_table :doctor_examination_comments do |t|
            t.bigint    :transaction_id
            t.integer   :condition_id
            t.bigint    :doctor_examination_id
            t.text      :comment
            t.timestamps
            t.bigint    :created_by
            t.bigint    :updated_by
            t.datetime  :deleted_at
        end

        add_index :doctor_examination_comments, :transaction_id
        add_index :doctor_examination_comments, :condition_id
        add_index :doctor_examination_comments, :doctor_examination_id
        add_index :doctor_examination_comments, :deleted_at
    end
end