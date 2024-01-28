# frozen_string_literal: true

module Report
  # Summary laboratory certification service for exporting
  class SummaryLaboratoryCertificationService
    attr_reader :transaction_details

    def initialize(start_date, end_date, group)
      @start_date = start_date
      @end_date = end_date
      @group = group
      @non_giro_groups = ServiceProviderGroup.where(category: 'Laboratory').without_giro.pluck(:id)
      @laboratory_data = nil
      @state_data = nil
      @stats = nil
      set_transaction_details
    end

    def result
      [laboratory_data, state_data, stats]
    end

    private

    def laboratory_data
      @laboratory_data ||=
        transaction_details_count
        .merge(transaction_details_rate_sum) { |_, count_value, rate_sum_value| [count_value, rate_sum_value] }
        .map { |k, v| [k, v].flatten }
        .sort_by { |p| [p[0], p[2], p[3], p[5], p[6], p[1]] } # order by Lab State,Lab Code,Lab Name,Worker Count,Amount,Group Code
    end

    def state_data
      @state_data ||=
        transaction_details_count(index: 0..1)
        .merge(transaction_details_rate_sum(index: 0..1)) { |_, count_value, rate_sum_value| [count_value, rate_sum_value] }
        .map { |k, v| [k, v].flatten }
        .sort
    end

    def stats
      {
        laboratories: {
          total_count: @laboratory_data.map { |row| row[5] }.sum,
          total_sum: @laboratory_data.map { |row| row[6] }.sum
        },
        states: {
          total_count: @state_data.map { |row| row[2] }.sum,
          total_sum: @state_data.map { |row| row[3] }.sum
        }
      }
    end

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

    def transaction_details_list
      @transaction_details
        .map { |detail| transaction_detail_mapping(detail) }
        .delete_if { |data| data.all?(&:blank?) }
        .map do |list|
          list[1] = group_code_display(list[1]) # replace nil service provider group to 'NON-GROUP'
          list
        end
    end

    def transaction_details_count(index: 0...-1)
      # group by state, doc_code, doc_name, clinic_name
      transaction_details_list
        .group_by { |a| a[index] }
        .map { |k, v| [k, v.size] }
        .to_h
    end

    def transaction_details_rate_sum(index: 0...-1)
      transaction_details_list
        .group_by { |a| a[index] }
        .map { |k, v| [k, v.map(&:last).sum] }
        .to_h
    end

    def transaction_detail_mapping(detail)
      gender = detail.transactionz.fw_gender == 'M' ? :male : :female
      [
        detail.lab_state_name.to_s,
        detail.lab_service_provider_group_id,
        detail.lab_code.to_s,
        detail.lab_name.to_s,
        payment_to(detail),
        detail.rate_for(:laboratory, gender)
      ]
    end

    def group_code_display(id)
      return 'NON-GROUP' if id.blank?

      ServiceProviderGroup.find(id).code
    end

    def scoped_transaction_details
      TransactionDetail.certification_date_between(@start_date, @end_date)
    end

    def payment_to(detail)
      return detail.lab_sp_group_name if detail.lab_service_provider_group_id.present?

      detail.lab_company_name.presence || detail.lab_name
    end
  end
end
