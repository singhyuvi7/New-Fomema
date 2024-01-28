module Transaction::SeedXqccQuarantine
    # def xqcc_review_criteria_check
    #     quarantine_reasons.pluck(:reason).sort
    # end -> Please refer to seed_quarantine.rb

    def checking_for_xqcc_quarantine_items
        @skip_seeding   = true
        @items          = []
        seed_xqcc_quarantine_items
        QuarantineReason.where(code: @items).pluck(:reason).sort
    end

    def seed_xqcc_quarantine_items
        if doctor_examination.present? && xray_examination.present?
            @qr_reason_id_map = QuarantineReason.pluck(:code, :id).to_h

            condition_to_xqcc_quarantine = {
                "2004" => ["5070"],
                "2011" => ["5030"],
                "2003" => ["5060"],
                "2013" => ["5050"],
                "2002" => ["5020"],
                "2001" => ["5010"],
                "2003" => ["5060"],
                "2012" => ["5040"],
            }

            case doctor_examination.try(:suitability)
            when "SUITABLE"
                xray_examination.xray_examination_details.joins(:condition).select("conditions.code").pluck(:code).each do |condition_code|
                    condition_to_xqcc_quarantine[condition_code].each do |quarantine_reason_code|
                        add_xqcc_quarantine_reason(quarantine_reason_code)
                    end
                end
                add_xqcc_quarantine_reason("5000") if xray_examination.try(:xray_examination_not_done) == "YES"
                add_xqcc_quarantine_reason("10000") if previous_transaction.try(:final_result) == "UNSUITABLE"
                add_xqcc_quarantine_reason("10011") if previous_transaction.try(:xray_result) == "UNSUITABLE"
            when "UNSUITABLE"
                add_xqcc_quarantine_reason("10012") if previous_transaction.try(:xray_result) == "UNSUITABLE"
            end
        end
    end
private
    def add_xqcc_quarantine_reason(quarantine_reason_code)
        if @skip_seeding
            @items << quarantine_reason_code
        else
            self.xqcc_quarantine_reasons.create(quarantine_reason_id: @qr_reason_id_map[quarantine_reason_code])
        end
    end
end
