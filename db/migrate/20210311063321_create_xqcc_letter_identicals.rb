class CreateXqccLetterIdenticals < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_identicals do |t|
            t.string :transaction_code
            t.string :xray_ref_no
            t.string :employer_ref_no
            t.string :retake_period
            t.string :reply_period
            t.string :issuer_name
            t.string :issuer_title
            t.string :xray_code
            t.string :doctor_code
            t.string :employer_code
            t.text   :xray_address
            t.text   :doctor_address
            t.text   :employer_address
            t.timestamps
        end

        add_index :xqcc_letter_identicals, :transaction_code
        add_index :xqcc_letter_identicals, :xray_ref_no
        add_index :xqcc_letter_identicals, :employer_ref_no
        add_index :xqcc_letter_identicals, :retake_period
        add_index :xqcc_letter_identicals, :reply_period
        add_index :xqcc_letter_identicals, :issuer_name
        add_index :xqcc_letter_identicals, :issuer_title
        add_index :xqcc_letter_identicals, :xray_code
        add_index :xqcc_letter_identicals, :doctor_code
        add_index :xqcc_letter_identicals, :employer_code
    end
end