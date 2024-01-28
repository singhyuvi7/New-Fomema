class CreateXqccLetterAuditRadiographers < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_audit_radiographers do |t|
            t.string :xray_ref_no
            t.string :issuer_name
            t.string :issuer_title
            t.integer :panel_year
            t.string :xray_code
            t.text   :xray_address
            t.timestamps
        end

        add_index :xqcc_letter_audit_radiographers, :xray_ref_no
        add_index :xqcc_letter_audit_radiographers, :issuer_name
        add_index :xqcc_letter_audit_radiographers, :issuer_title
        add_index :xqcc_letter_audit_radiographers, :panel_year
        add_index :xqcc_letter_audit_radiographers, :xray_code
    end
end