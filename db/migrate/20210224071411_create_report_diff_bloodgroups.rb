class CreateReportDiffBloodgroups < ActiveRecord::Migration[6.0]
    def change
        create_table :report_diff_bloodgroups do |t|
            t.bigint    :transaction_id
            t.datetime  :certification_date
            t.string    :foreign_worker_code
            t.string    :foreign_worker_name
            t.string    :doctor_code_1
            t.string    :doctor_code_2
            t.string    :doctor_code_3
            t.string    :lab_code_1
            t.string    :lab_code_2
            t.string    :lab_code_3
            t.string    :transaction_code_1
            t.string    :transaction_code_2
            t.string    :transaction_code_3
            t.string    :blood_group_1
            t.string    :blood_group_2
            t.string    :blood_group_3
            t.string    :rhesus_1
            t.string    :rhesus_2
            t.string    :rhesus_3
            t.timestamps
        end

        add_index :report_diff_bloodgroups, :transaction_id, unique: true
        add_index :report_diff_bloodgroups, :certification_date
        add_index :report_diff_bloodgroups, :doctor_code_3
        add_index :report_diff_bloodgroups, :lab_code_3
    end
end