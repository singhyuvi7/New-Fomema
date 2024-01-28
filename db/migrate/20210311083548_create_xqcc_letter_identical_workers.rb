class CreateXqccLetterIdenticalWorkers < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_identical_workers do |t|
            t.integer :xqcc_letter_identical_id
            t.string  :worker_code
            t.string  :worker_name
            t.string  :worker_passport
            t.date    :xray_date
            t.date    :audit_date
            t.string  :employer_name
            t.timestamps
        end

        add_index :xqcc_letter_identical_workers, :xqcc_letter_identical_id, name: "xqqciw_identical_id"
        add_index :xqcc_letter_identical_workers, :worker_code
        add_index :xqcc_letter_identical_workers, :worker_name
        add_index :xqcc_letter_identical_workers, :worker_passport
        add_index :xqcc_letter_identical_workers, :xray_date
        add_index :xqcc_letter_identical_workers, :audit_date
        add_index :xqcc_letter_identical_workers, :employer_name
    end
end