class CreateXqccLetterMisreads < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_misreads do |t|
            t.string :transaction_code
            t.string :xray_ref_no
            t.string :employer_ref_no
            t.string :amended_status
            t.string :xray_code
            t.string :doctor_code
            t.string :employer_code
            t.string :worker_code
            t.string :worker_name
            t.string :worker_passport
            t.text   :xray_address
            t.text   :doctor_address
            t.text   :employer_address
            t.timestamps
        end

        add_index :xqcc_letter_misreads, :transaction_code
        add_index :xqcc_letter_misreads, :xray_ref_no
        add_index :xqcc_letter_misreads, :employer_ref_no
        add_index :xqcc_letter_misreads, :amended_status
        add_index :xqcc_letter_misreads, :xray_code
        add_index :xqcc_letter_misreads, :doctor_code
        add_index :xqcc_letter_misreads, :employer_code
        add_index :xqcc_letter_misreads, :worker_code
        add_index :xqcc_letter_misreads, :worker_name
        add_index :xqcc_letter_misreads, :worker_passport
    end
end