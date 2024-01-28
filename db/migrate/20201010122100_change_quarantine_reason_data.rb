class ChangeQuarantineReasonData < ActiveRecord::Migration[6.0]
    def change
        QuarantineReason.find_or_initialize_by(code: "10008").update(reason: "In-House PCR does not agree with the Digital X-Ray finding.")
        QuarantineReason.find_or_initialize_by(code: "10013").update(reason: "In-House PCR does not agree with the Digital X-Ray finding. Case transferred by XQCC Department.")
    end
end