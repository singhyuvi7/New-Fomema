class XqccPool < ApplicationRecord
    STATUSES = {
        "XQCC_POOL" => "XQCC POOL",
        "ASSIGN" => "ASSIGN",
    }

    CASE_TYPES = {
        "XRAY_EXAMINATION_NORMAL" => "XRAY EXAMINATION: NORMAL",
        "XQCC_PENDING_REVIEW_XQCC_POOL" => "XQCC PENDING REVIEW: RADIOGRAPHER REVIEW",
    }

    SOURCES = {
        "MERTS" => "MERTS",
        "PENDING_REVIEW" => "XQCC PENDING REVIEW"
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include XrayMovement

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :sourceable, polymorphic: true, optional: true
    belongs_to :picked_up_by_user, :class_name => :User, :foreign_key => "picked_up_by", optional: true

    has_one :xray_review, as: :poolable

    # scopes
    scope :pending, -> {
        where(status: 'XQCC_POOL').where(picked_up_by: nil)
    }

    scope :pending_reported, -> {
        where(status: 'XQCC_POOL').where(picked_up_by: nil).joins(:transactionz).where(transactions: { certification_date: nil })
    }

    scope :pending_total_certified, -> {
        where(status: 'XQCC_POOL').where(picked_up_by: nil).joins(:transactionz).where.not(transactions: { certification_date: nil })
    }

    scope :reserved, ->(by) {
        where(reserved_by: by)
    }

    scope :xray_facility_id, -> xray_facility_id {
        joins(:transactionz).where(transactions: { xray_facility_id: xray_facility_id })
    }

    scope :digital, -> {
        where("exists (select 1 from transactions where transactions.id = xqcc_pools.transaction_id and transactions.xray_film_type = 'DIGITAL')")
    }

    scope :analog, -> {
        where("exists (select 1 from transactions where transactions.id = xqcc_pools.transaction_id and transactions.xray_film_type = 'ANALOG')")
    }

    scope :date_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }

    scope :certification_date_between, ->(start_date, end_date) {
        joins(:transactionz).where(transactions: { certification_date: start_date..end_date })
    }
    # end of scopes

    def pickup_xqcc(batch_id, picked_up_by)
        self.update({
            status: 'ASSIGN',
            picked_up_by: picked_up_by,
            picked_up_at: Time.now,
            reserved_by: nil
        })

        # create xray_review
        xray_review = XrayReview.create({
            transaction_id: self.transaction_id,
            poolable_type: XqccPool.to_s,
            poolable_id: self.id,
            case_type: self.case_type,
            batch_id: batch_id,
            status: 'XQCC_REVIEW',
            radiographer_id: picked_up_by
        })

        # update transaction status
        if transaction_id?
            self.transactionz.update({
                xray_review_id: xray_review.id,
                xray_status: 'XQCC_REVIEW'
            })
        end

        return xray_review
    end

end
