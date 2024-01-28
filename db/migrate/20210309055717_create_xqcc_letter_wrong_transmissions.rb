class CreateXqccLetterWrongTransmissions < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_wrong_transmissions do |t|
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

        add_index :xqcc_letter_wrong_transmissions, :transaction_code
        add_index :xqcc_letter_wrong_transmissions, :xray_ref_no
        add_index :xqcc_letter_wrong_transmissions, :employer_ref_no
        add_index :xqcc_letter_wrong_transmissions, :amended_status
        add_index :xqcc_letter_wrong_transmissions, :xray_code
        add_index :xqcc_letter_wrong_transmissions, :doctor_code
        add_index :xqcc_letter_wrong_transmissions, :employer_code
        add_index :xqcc_letter_wrong_transmissions, :worker_code
        add_index :xqcc_letter_wrong_transmissions, :worker_name
        add_index :xqcc_letter_wrong_transmissions, :worker_passport
    end
end