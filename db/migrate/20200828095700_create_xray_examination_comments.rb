class CreateXrayExaminationComments < ActiveRecord::Migration[6.0]
    def change
        create_table :xray_examination_comments do |t|
            t.bigint    :transaction_id
            t.integer   :condition_id
            t.bigint    :xray_examination_id
            t.text      :comment
            t.timestamps
            t.bigint    :created_by
            t.bigint    :updated_by
            t.datetime  :deleted_at
        end

        add_index :xray_examination_comments, :transaction_id
        add_index :xray_examination_comments, :condition_id
        add_index :xray_examination_comments, :xray_examination_id
        add_index :xray_examination_comments, :deleted_at
    end
end