class CreateXqccLetterNonCompliances < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_letter_non_compliances do |t|
            t.string :xray_ref_no
            t.string :issuer_name
            t.string :issuer_title
            t.string :xray_code
            t.text   :xray_address
            t.timestamps
        end

        add_index :xqcc_letter_non_compliances, :xray_ref_no
        add_index :xqcc_letter_non_compliances, :issuer_name
        add_index :xqcc_letter_non_compliances, :issuer_title
        add_index :xqcc_letter_non_compliances, :xray_code
    end
end