class CreateNonComplianceItems < ActiveRecord::Migration[6.0]
    def change
        create_table :non_compliance_items do |t|
            t.integer :xqcc_letter_non_compliance_id
            t.string  :name
            t.integer :total
            t.timestamps
        end

        add_index :non_compliance_items, :xqcc_letter_non_compliance_id, name: "ncti2_non_compliance_id"
        add_index :non_compliance_items, :name
        add_index :non_compliance_items, :total
    end
end