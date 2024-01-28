# frozen_string_literal: true

module Report
  ## note : reports data from migration will never be tally if view by group or non group due to service provider data migrate differently. if service provider is the only provider under a group, it will be migrated as non group (data from old system will be under group). Amount will be tally if view 'All'

  # Doctor certification details for exporting
  class DoctorCertificationDetailService
    attr_reader :transaction_details

    def initialize(start_date, end_date, group, sp_code)
      @start_date = start_date
      @end_date = end_date
      @group = group
      @non_giro_groups = ServiceProviderGroup.where(category: 'Doctor').without_giro.pluck(:id)
      @sp_code = sp_code
      set_transaction_details
    end

    def result
      @transaction_details.order(%i[certification_date]).decorate.map do |detail|
        gender = detail.fw_gender == 'M' ? :male : :female
        [
          detail.doc_code, detail.doc_name, detail.doc_clinic_name,
          detail.doc_full_address, detail.fw_code, detail.fw_name,
          detail.certification_date, detail.fw_gender,
          detail.rate_for(:doctor, gender),
          detail.doc_group_code,
          payment_to(detail),
          detail.document_number
        ]
      end
    end

    private

    def set_transaction_details
      case @group
      when 'all'
        @transaction_details = scoped_transaction_details
      when 'non_group'
        @transaction_details = scoped_transaction_details.where(doc_service_provider_group_id: nil)
      when 'group_giro'
        # group and payment type = GIRO
        @transaction_details =
          scoped_transaction_details
          .joins(:doc_sp_group_payment_method)
          .where.not(doc_service_provider_group_id: nil)
          .where(payment_methods: { payment_code: ['OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT'] })
      when *@non_giro_groups.map(&:to_s)
        # list of group doctor with payment type not Giro (existing in old system)
        @transaction_details = scoped_transaction_details.where(doc_service_provider_group_id: @group)
      else
        @transaction_details = scoped_transaction_details
      end
    end

    def scoped_transaction_details
      TransactionDetail
        .certification_date_between(@start_date, @end_date)
        .with_doctor_code(@sp_code)
        .joins("LEFT JOIN sp_fin_batch_items ON transaction_details.transaction_id = sp_fin_batch_items.transaction_id and sp_fin_batch_items.itemable_type = 'Doctor'")
        .select("transaction_details.*, sp_fin_batch_items.document_number")
    end

    def payment_to(detail)
      return detail.doc_sp_group_name if detail.doc_service_provider_group_id.present?

      detail.doc_company_name.presence || detail.doc_name
    end
  end
end
