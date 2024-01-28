class AddCreatedAndUpdatedByToXqccLetters < ActiveRecord::Migration[6.0]
    def change
        add_column :xqcc_letter_wrong_transmissions, :created_by, :integer
        add_column :xqcc_letter_misreads, :created_by, :integer
        add_column :xqcc_letter_audit_results, :created_by, :integer
        add_column :xqcc_letter_active_tbs, :created_by, :integer
        add_column :xqcc_letter_audit_radiographers, :created_by, :integer
        add_column :xqcc_letter_non_compliances, :created_by, :integer
        add_column :xqcc_letter_identicals, :created_by, :integer
        add_index :xqcc_letter_wrong_transmissions, :created_by
        add_index :xqcc_letter_misreads, :created_by
        add_index :xqcc_letter_audit_results, :created_by
        add_index :xqcc_letter_active_tbs, :created_by
        add_index :xqcc_letter_audit_radiographers, :created_by
        add_index :xqcc_letter_non_compliances, :created_by
        add_index :xqcc_letter_identicals, :created_by

        add_column :xqcc_letter_wrong_transmissions, :updated_by, :integer
        add_column :xqcc_letter_misreads, :updated_by, :integer
        add_column :xqcc_letter_audit_results, :updated_by, :integer
        add_column :xqcc_letter_active_tbs, :updated_by, :integer
        add_column :xqcc_letter_audit_radiographers, :updated_by, :integer
        add_column :xqcc_letter_non_compliances, :updated_by, :integer
        add_column :xqcc_letter_identicals, :updated_by, :integer
        add_index :xqcc_letter_wrong_transmissions, :updated_by
        add_index :xqcc_letter_misreads, :updated_by
        add_index :xqcc_letter_audit_results, :updated_by
        add_index :xqcc_letter_active_tbs, :updated_by
        add_index :xqcc_letter_audit_radiographers, :updated_by
        add_index :xqcc_letter_non_compliances, :updated_by
        add_index :xqcc_letter_identicals, :updated_by
    end
end