class SequenceForXqccMisreadAndAuditResults < ActiveRecord::Migration[6.0]
    def up
        sql = "create sequence xqcc_misread_letter_seq
        increment 1
        minvalue 1
        maxvalue 9999
        cycle
        start with 1"
        execute sql

        sql = "create sequence xqcc_audit_result_letter_seq
        increment 1
        minvalue 1
        maxvalue 9999
        cycle
        start with 1"
        execute sql
    end

    def down
        execute "drop sequence xqcc_misread_letter_seq;"
        execute "drop sequence xqcc_audit_result_letter_seq;"
    end
end
