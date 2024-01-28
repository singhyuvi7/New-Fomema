class CreateSequenceForAppealXrayRetakes < ActiveRecord::Migration[6.0]
    def change
        create_table :sequence_for_appeal_xray_retakes do |t|
            sql = "create sequence medical_appeal_xray_retake_code_seq
            increment 1
            minvalue 1
            maxvalue 999999999999
            cycle
            start with 1"
            execute sql
        end
    end
end