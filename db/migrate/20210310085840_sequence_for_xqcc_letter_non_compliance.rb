class SequenceForXqccLetterNonCompliance < ActiveRecord::Migration[6.0]
    def up
        sql = "create sequence xqcc_non_compliance_letter_seq
        increment 1
        minvalue 1
        maxvalue 9999
        cycle
        start with 1"
        execute sql
    end

    def down
        execute "drop sequence xqcc_non_compliance_letter_seq;"
    end
end