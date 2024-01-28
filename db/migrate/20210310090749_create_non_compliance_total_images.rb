class CreateNonComplianceTotalImages < ActiveRecord::Migration[6.0]
    def change
        create_table :non_compliance_total_images do |t|
            t.integer :xqcc_letter_non_compliance_id
            t.string  :month
            t.string  :total_images
            t.string  :sop_compliant
            t.string  :non_sop_compliant
            t.timestamps
        end

        add_index :non_compliance_total_images, :xqcc_letter_non_compliance_id, name: "ncti_non_compliance_id"
        add_index :non_compliance_total_images, :month
        add_index :non_compliance_total_images, :total_images
        add_index :non_compliance_total_images, :sop_compliant
        add_index :non_compliance_total_images, :non_sop_compliant
    end
end