class AddXrayNameToAllXqccLetters < ActiveRecord::Migration[6.0]
    def change
        add_column :xqcc_letter_wrong_transmissions, :xray_name, :string
        add_column :xqcc_letter_misreads, :xray_name, :string
        add_column :xqcc_letter_audit_results, :xray_name, :string
        add_column :xqcc_letter_active_tbs, :xray_name, :string
        add_column :xqcc_letter_audit_radiographers, :xray_name, :string
        add_column :xqcc_letter_non_compliances, :xray_name, :string
        add_column :xqcc_letter_identicals, :xray_name, :string
        add_index :xqcc_letter_wrong_transmissions, :xray_name
        add_index :xqcc_letter_misreads, :xray_name
        add_index :xqcc_letter_audit_results, :xray_name
        add_index :xqcc_letter_active_tbs, :xray_name
        add_index :xqcc_letter_audit_radiographers, :xray_name
        add_index :xqcc_letter_non_compliances, :xray_name
        add_index :xqcc_letter_identicals, :xray_name
    end
end
