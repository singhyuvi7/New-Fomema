# frozen_string_literal: true

module Report
  #  xray_facility certification detail service for exporting
  class XrayFacilityCertificationDetailService
    attr_reader :transaction_details

    def initialize(start_date, end_date, group, sp_code)
      @start_date = start_date
      @end_date = end_date
      @group = group
      @non_giro_groups = ServiceProviderGroup.where(category: 'XrayFacility').without_giro.pluck(:id)
      @sp_code = sp_code
      set_transaction_details
    end

    def result
      @transaction_details.order(%i[certification_date]).decorate.map do |detail|
        gender = detail.fw_gender == 'M' ? :male : :female
        [
          detail.xray_code, detail.xray_license_holder_name, detail.xray_name,
          detail.xray_full_address, detail.fw_code, detail.fw_name,
          detail.certification_date, detail.fw_gender,
          detail.rate_for(:xray_facility, gender), detail.xray_group_code,
          payment_to(detail), detail.digital_xray_provider, detail.document_number
        ]
      end
    end

    private

    def set_transaction_details
      case @group
      when 'all'
        @transaction_details = scoped_transaction_details
      when 'non_group'
        @transaction_details = scoped_transaction_details.where(xray_service_provider_group_id: nil)
      when 'group_giro'
        # group and payment type = GIRO
        @transaction_details =
          scoped_transaction_details
          .joins(:xray_sp_group_payment_method)
          .where.not(xray_service_provider_group_id: nil)
          .where(payment_methods: { payment_code: 'GIRO' })
      when *@non_giro_groups.map(&:to_s)
        @transaction_details = scoped_transaction_details.where(xray_service_provider_group_id: @group)
      else
        @transaction_details = scoped_transaction_details
      end
    end

    def scoped_transaction_details
      TransactionDetail.certification_date_between(@start_date, @end_date).with_xray_code(@sp_code)
      .joins("LEFT JOIN sp_fin_batch_items ON transaction_details.transaction_id = sp_fin_batch_items.transaction_id and sp_fin_batch_items.itemable_type = 'XrayFacility'")
      .select("transaction_details.*, sp_fin_batch_items.document_number")
    end

    def payment_to(detail)
      return detail.xray_sp_group_name if detail.xray_service_provider_group_id.present?

      detail.xray_company_name.presence || detail.xray_name
    end
  end
end
