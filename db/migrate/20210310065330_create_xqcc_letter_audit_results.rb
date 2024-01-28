class CreateXqccLetterAuditResults < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_audit_results do |t|
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

        add_index :xqcc_letter_audit_results, :transaction_code
        add_index :xqcc_letter_audit_results, :xray_ref_no
        add_index :xqcc_letter_audit_results, :employer_ref_no
        add_index :xqcc_letter_audit_results, :amended_status
        add_index :xqcc_letter_audit_results, :xray_code
        add_index :xqcc_letter_audit_results, :doctor_code
        add_index :xqcc_letter_audit_results, :employer_code
        add_index :xqcc_letter_audit_results, :worker_code
        add_index :xqcc_letter_audit_results, :worker_name
        add_index :xqcc_letter_audit_results, :worker_passport
    end
end