class CreateXqccLetterActiveTbs < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_active_tbs do |t|
            t.string :transaction_code
            t.string :xray_ref_no
            t.string :employer_ref_no
            t.string :issuer_name
            t.string :issuer_title
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

        add_index :xqcc_letter_active_tbs, :transaction_code
        add_index :xqcc_letter_active_tbs, :xray_ref_no
        add_index :xqcc_letter_active_tbs, :employer_ref_no
        add_index :xqcc_letter_active_tbs, :issuer_name
        add_index :xqcc_letter_active_tbs, :issuer_title
        add_index :xqcc_letter_active_tbs, :xray_code
        add_index :xqcc_letter_active_tbs, :doctor_code
        add_index :xqcc_letter_active_tbs, :employer_code
        add_index :xqcc_letter_active_tbs, :worker_code
        add_index :xqcc_letter_active_tbs, :worker_name
        add_index :xqcc_letter_active_tbs, :worker_passport
    end
end