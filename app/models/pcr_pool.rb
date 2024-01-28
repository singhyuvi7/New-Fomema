class PcrPool < ApplicationRecord
    STATUSES = {
        "PCR_POOL" => "PCR_POOL",
        "ASSIGN" => "ASSIGN",
    }

    CASE_TYPES = {
        "XQCC_PENDING_REVIEW_PCR_POOL" => "XQCC_PENDING_REVIEW_PCR_POOL",
        "XQCC_REVIEW_IDENTICAL" => "XQCC_REVIEW_IDENTICAL",
        "XQCC_REVIEW_IQA" => "XQCC_REVIEW_IQA",
        "XQCC_REVIEW_SUSPICIOUS" => "XQCC_REVIEW_SUSPICIOUS",
        "XQCC_REVIEW_WRONGLY_TRANSMITTED" => "XQCC_REVIEW_WRONGLY_TRANSMITTED",
        "XRAY_APPEAL_NORMAL" => "XRAY_APPEAL_NORMAL",
        "XRAY_EXAMINATION_ABNORMAL" => "XRAY_EXAMINATION_ABNORMAL"
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include ParentTransactionScope
    include XrayMovement

    belongs_to :transactionz,       foreign_key: "transaction_id", class_name: "Transaction", optional: true
    belongs_to :medical_appeal,     foreign_key: "medical_appeal_id", class_name: "MedicalAppeal", optional: true
    belongs_to :sourceable,         polymorphic: true, optional: true
    belongs_to :picked_up_by_user,  class_name: "User", foreign_key: "picked_up_by", optional: true
    belongs_to :xray_retake,        optional: true

    has_one :pcr_review,            as: :poolable

    scope :pending, -> {
        where(status: 'PCR_POOL')
    }

    scope :not_same_appeal, lambda {|user|
        appeal_ids = PcrPool.unscoped.joins(:xray_retake).where(picked_up_by: user.id, xray_retakes: { current_appeal_retake: true }).where.not(medical_appeal_id: nil).pluck(:medical_appeal_id)
        appeal_ids = [0] if appeal_ids.blank? # SQL query breaks if array is empty.
        where("pcr_pools.medical_appeal_id IS NULL OR pcr_pools.medical_appeal_id NOT IN (?)", appeal_ids)
    }

    scope :not_same_radiologist, lambda { |radiologist_id| 
        return all if radiologist_id.blank?
        joins("left join transactions on pcr_pools.transaction_id = transactions.id")
        .where("(transactions.xray_reporter_type is null OR transactions.xray_reporter_type != 'RADIOLOGIST' OR (transactions.xray_reporter_type = 'RADIOLOGIST' and transactions.radiologist_id != ?)) and not exists (select 1 from panel_radiologists where panel_radiologists.xray_facility_id = transactions.xray_facility_id and panel_radiologists.radiologist_id = ?)", radiologist_id, radiologist_id)
    }

    def pickup_pcr(picked_up_by)
        picked_up_at = Time.now
        self.update(status: 'ASSIGN', picked_up_by: picked_up_by, picked_up_at: picked_up_at)

        # create pcr_review
        pcr_review = PcrReview.create({
            transaction_id: self.transaction_id,
            poolable_type: PcrPool.to_s,
            poolable_id: self.id,
            case_type: self.case_type,
            status: 'PCR_REVIEW',
            pcr_id: picked_up_by,
            medical_appeal_id: medical_appeal_id
        })

        # update transaction status
        if transaction_id?
            self.transactionz.update({
                xray_status: 'PCR_REVIEW',
                pcr_review_id: pcr_review.id
            })
        elsif medical_appeal_id?
            appeal_retake = self.xray_retake
            appeal_retake.update(pcr_id: picked_up_by, pcr_picked_up_at: picked_up_at)
        end

        return pcr_review
    end
end