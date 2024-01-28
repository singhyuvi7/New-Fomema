# frozen_string_literal: true

module Report
  # laboratory certification detail service for exporting
  class LaboratoryCertificationDetailService
    attr_reader :transaction_details

    def initialize(start_date, end_date, group, sp_group_code, sp_code)
      @start_date = start_date
      @end_date = end_date
      @group = group
      @non_giro_groups = ServiceProviderGroup.where(category: 'Laboratory').without_giro.pluck(:id)
      @sp_code = sp_code
      @sp_group_code = sp_group_code
      set_transaction_details
    end

    def result
      @transaction_details.order(%i[certification_date])
        .decorate
        .map { |detail| transaction_detail_mapping(detail) }
        # p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[9], p[8], p[10]
        # order byLab Code,Lab Name,Address,Trans ID,Worker Code,Worker Name,Certify Date,Gender,Branch,Registered,Amount,Group Code
    end

    private

    def set_transaction_details
      case @group
      when 'all'
        @transaction_details = scoped_transaction_details
      when 'non_group'
        @transaction_details = scoped_transaction_details.where(lab_service_provider_group_id: nil)
      when 'group_giro'
        # group and payment type = GIRO
        @transaction_details =
          scoped_transaction_details
          .joins(:lab_sp_group_payment_method)
          .where.not(lab_service_provider_group_id: nil)
          .where(payment_methods: { payment_code: 'GIRO' })
      when *@non_giro_groups.map(&:to_s)
        # list of group with payment type not Giro (existing in old system)
        @transaction_details = scoped_transaction_details.where(lab_service_provider_group_id: @group)
      else
        @transaction_details = scoped_transaction_details
      end
    end

    def scoped_transaction_details
      TransactionDetail
        .certification_date_between(@start_date, @end_date)
        .with_laboratory_group_code(@sp_group_code)
        .with_laboratory_code(@sp_code)
        .joins("LEFT JOIN sp_fin_batch_items ON transaction_details.transaction_id = sp_fin_batch_items.transaction_id and sp_fin_batch_items.itemable_type = 'Laboratory'")
        .select("transaction_details.*, sp_fin_batch_items.document_number")
    end

    def payment_to(detail)
      return detail.lab_sp_group_name if detail.lab_service_provider_group_id.present?

      detail.lab_company_name.presence || detail.lab_name
    end

    def transaction_detail_mapping(detail)
      gender = detail.fw_gender == 'M' ? :male : :female
      [
        detail.lab_code.to_s,
        detail.lab_name.to_s,
        detail.lab_full_address.to_s,
        detail.transactionz_code.to_s,
        detail.fw_code.to_s,
        detail.fw_name.to_s,
        detail.certification_date,
        detail.fw_gender.to_s,
        detail.rate_for(:laboratory, gender),
        detail.organization_code.to_s,
        detail.lab_group_code.to_s,
        payment_to(detail),
        detail.document_number
      ]
    end
  end
end
