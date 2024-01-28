# frozen_string_literal: true

module Report
  # PCR Audit Summary report service
  class PcrAuditSummaryService
    attr_reader :transactions, :pcr_user, :errors, :radiologist

    def initialize(start_date, end_date, code, user_id)
      @start_date = start_date.presence
      @end_date = end_date.presence
      @code = code.presence
      @user_id = user_id
      @pcr_user = set_pcr_user
      @radiologist = set_radiologist
      @transactions = set_transactions
    end

    def result
      transactions
        .group_by { |transaction| group_by_attributes(transaction) }
        .map { |k, v| [k, v.size] }
        .map(&:flatten)
        .sort
    end

    def valid?
      @start_date.present? &&
        @end_date.present? &&
        @pcr_user.present?
    end

    private

    def set_transactions
      Transaction
        .includes(:xray_facility, :pcr_reviews)
        .where(id: [pcr_review_transactions.ids + pcr_appeal_transactions.ids].uniq.sort)
    end

    def pcr_review_transactions
      Transaction
        .joins(:pcr_reviews)
        .includes(:xray_facility, :pcr_reviews)
        .where(pcr_reviews: { status: 'TRANSMITTED' })
        .where.not(pcr_reviews: { result: 'RETAKE' })
        .pcr_transmitted_at_date_between(@start_date, @end_date)
        .then { |resources| transaction_pcr_reviews_by_user(resources) }
    end

    def pcr_appeal_transactions
      Transaction
        .joins(medical_appeals: :pcr_reviews)
        .where(pcr_reviews: { status: 'TRANSMITTED' })
        .where.not(pcr_reviews: { result: 'RETAKE' })
        .where(pcr_reviews: { transmitted_at: DateTime.parse(@start_date).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(@end_date).in_time_zone('Kuala Lumpur').end_of_day })
        .then { |resources| transaction_pcr_reviews_by_user(resources) }
    end

    def set_pcr_user
      return User.find(@user_id) if @user_id.present?

      User.find_by(id: Radiologist.find_by(code: @code)&.user_id)
    end

    def set_radiologist
      return unless @pcr_user
      return unless @pcr_user.userable_type == 'Radiologist'

      @pcr_user.userable
    end

    def transaction_pcr_reviews_by_user(resources)
      return Transaction.none if @pcr_user.blank?

      resources.where(pcr_reviews: { pcr_id: @pcr_user.id })
    end

    def group_by_attributes(transaction)
      [
        transaction.latest_pcr_review&.transmitted_at&.strftime('%d-%m-%Y'),
        transaction.xray_facility_code,
        transaction.xray_facility_name
      ]
    end
  end
end
