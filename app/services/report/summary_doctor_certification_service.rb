# frozen_string_literal: true

module Report
  # Summary doctor certification service for exporting
  class SummaryDoctorCertificationService
    attr_reader :transaction_details

    def initialize(start_date, end_date, group)
      @start_date = start_date
      @end_date = end_date
      @group = group
      @non_giro_groups = ServiceProviderGroup.where(category: 'Doctor').without_giro.pluck(:id)
      @doctor_data = nil
      @state_data = nil
      @stats = nil
      set_transaction_details
    end

    def result
      [doctor_data, state_data, stats]
    end

    private

    def doctor_data
      @doctor_data ||=
        transaction_details_count
        .merge(transaction_details_rate_sum) { |_, count_value, rate_sum_value| [count_value, rate_sum_value] }
        .map { |k, v| [k, v].flatten }
        .sort_by { |p| [p[0], p[2], p[3], p[4], p[6], p[7], p[1]] } # order by Doctor State,Doctor Code,Doctor Name,Clinic Name,Worker Count,Amount,Group Code
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
        doctors: {
          total_count: @doctor_data.map { |row| row[6] }.sum,
          total_sum: @doctor_data.map { |row| row[7] }.sum
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
        @transaction_details = TransactionDetail.certification_date_between(@start_date, @end_date)
      when 'non_group'
        @transaction_details = TransactionDetail.certification_date_between(@start_date, @end_date).where(doc_service_provider_group_id: nil)
      when 'group_giro'
        # group and payment type = GIRO
        @transaction_details =
          TransactionDetail
          .joins(:doc_sp_group_payment_method)
          .where.not(doc_service_provider_group_id: nil)
          .where(payment_methods: { payment_code: 'GIRO' })
          .certification_date_between(@start_date, @end_date)
      when *@non_giro_groups.map(&:to_s)
        # list of group doctor with payment type not Giro (existing in old system)
        @transaction_details = TransactionDetail.certification_date_between(@start_date, @end_date).where(doc_service_provider_group_id: @group)
      else
        @transaction_details = TransactionDetail.certification_date_between(@start_date, @end_date)
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
        detail.doc_state_name,
        detail.doc_service_provider_group_id,
        detail.doc_code,
        detail.doc_name,
        detail.doc_clinic_name,
        payment_to(detail),
        detail.rate_for(:doctor, gender)
      ]
    end

    def group_code_display(id)
      return 'NON-GROUP' if id.blank?

      ServiceProviderGroup.find(id).code
    end

    def payment_to(detail)
      return detail.doc_sp_group_name if detail.doc_service_provider_group_id.present?

      detail.doc_company_name.presence || detail.doc_name
    end
  end
end
