# frozen_string_literal: true

module Report
  # xray not done certification service for exporting
  class XrayNotDoneCertificationService
    attr_reader :transactions

    def initialize(start_date, end_date, group)
      @start_date = start_date
      @end_date = end_date
      @group = group
      @non_giro_groups = ServiceProviderGroup.where(category: 'XrayFacility').without_giro.pluck(:id)
      set_transactions
    end

    def result
      @transactions
        .decorate
        .map { |transaction| transaction_mapping(transaction) }
        .sort
    end

    private

    def set_transactions
      case @group
      when 'all'
        @transactions = filtered_transaction
      when 'non_group'
        @transactions = filtered_transaction.where(transaction_details: { xray_service_provider_group_id: nil })
      when 'group_giro'
        @transactions =
          filtered_transaction
          .joins('join payment_methods on transaction_details.xray_sp_group_payment_method_id = payment_methods.id')
          .where.not(transaction_details: {xray_service_provider_group_id: nil})
          .where(payment_methods: { payment_code: 'GIRO' })
      when *@non_giro_groups.map(&:to_s)
        @transactions = filtered_transaction.where(transaction_details: { xray_service_provider_group_id: @group })
      else
        @transactions = filtered_transaction
      end
    end

    def filtered_transaction
      Transaction
        .joins(:transaction_detail, :xray_examination)
        .certified_between(@start_date, @end_date)
        .where(xray_examinations: { xray_examination_not_done: 'YES' }) # yes for not done, no for done
    end

    def transaction_mapping(transaction)
      [
        transaction.detail_xray_state_name,
        transaction.detail_xray_code,
        transaction.detail_xray_license_holder_name,
        transaction.detail_xray_name,
        transaction.fw_code,
        transaction.object.certification_date.strftime('%d/%m/%Y'),
        transaction.transaction_rate(service_provider: :xray_facility),
        transaction.transaction_detail&.xray_group_code
      ]
    end
  end
end
