# frozen_string_literal: true

module Report
  # delay transmission statistic data
  class DelayTransmissionStatistic
    attr_reader :transactions, :delays

    def initialize(source, params)
      @source = source
      @start_date = params[:transaction_date_from]
      @end_date = params[:transaction_date_to]
      @doctor_code = params[:doctor_code]
      @laboratory_code = params[:laboratory_code]
      @xray_code = params[:xray_code]
      @transactions = filtered_transactions
    end

    def result
      doctor_list
    end

    private

    def doctor_list
      transaction_count_unique_keys
        .sort_by { |p| [p[1], p[3], p[4]] } # sort by doctor name, lab name and year
        .map { |doctor_list| transform_to_hash(doctor_list) }
    end

    def filtered_transactions
      # query current and previous year
      Transaction
        .joins(:xray_examination)
        .includes(:doctor, :laboratory)
        .current_and_past_years
        .where.not(xray_transmit_date: nil)
        .transaction_date_between(@start_date, @end_date)
        .with_doctor_code(@doctor_code)
        .with_laboratory_code(@laboratory_code)
        .with_xray_code(@xray_code)
    end

    def transaction_delay_list
      @delays = @transactions.map { |transaction| transaction_mapping(transaction) }
    end

    def transaction_mapping(transaction)
      [
        transaction.doctor_code,
        transaction.doctor_name,
        transaction.service_provider_code_for(@source),
        transaction.service_provider_name_for(@source),
        transaction.created_at.year,
        transaction.delay_status_for(@source)
      ]
    end

    def transaction_count(index: 0..-1)
      @transaction_count ||=
        transaction_delay_list
        .group_by { |transaction| transaction[index] }
        .map { |k, v| [k, v.size] }
        .to_h
    end

    def transaction_count_unique_keys
      transaction_count
        .keys
        .map { |a| a.take(4) }
        .uniq
    end

    def transform_to_hash(doctor_list)
      # TODO: refactor codes in current methods
      doc_code, doc_name, lab_code, lab_name = doctor_list
      current_year = DateTime.current.year
      past_year = 1.year.ago.year

      # Past and current year delay and non-delay quantity
      past_delay_quantity = transaction_count.dig([*doctor_list, past_year, 'DELAY']).to_i
      past_non_delay_quantity = transaction_count.dig([*doctor_list, past_year, 'NON-DELAY']).to_i
      current_delay_quantity = transaction_count.dig([*doctor_list, current_year, 'DELAY']).to_i
      current_non_delay_quantity = transaction_count.dig([*doctor_list, current_year, 'NON-DELAY']).to_i
      past_total_quantity = past_delay_quantity + past_non_delay_quantity
      current_total_quantity = current_delay_quantity + current_non_delay_quantity

      # Past and current year delay and non-delay percentage
      past_delay_percentage = BigDecimal(past_delay_quantity) / BigDecimal(past_total_quantity) * 100
      past_non_delay_percentage = BigDecimal(past_non_delay_quantity) / BigDecimal(past_total_quantity) * 100
      past_total_percentage = past_delay_percentage + past_non_delay_percentage
      current_delay_percentage = BigDecimal(current_delay_quantity) / BigDecimal(current_total_quantity) * 100
      current_non_delay_percentage = BigDecimal(current_non_delay_quantity) / BigDecimal(current_total_quantity) * 100
      current_total_percentage = current_delay_percentage + current_non_delay_percentage

      {
        doctor_name: doc_name,
        doctor_code: doc_code,
        laboratory_name: lab_name,
        laboratory_code: lab_code,
        years: [past_year, current_year],
        data: {
          past_year => {
            total_count: past_total_quantity,
            total_percent: past_total_percentage.finite? ? past_total_percentage : 0,
            not_delay: {
              count: past_non_delay_quantity,
              percent: past_non_delay_percentage.finite? ? past_non_delay_percentage : 0
            },
            delay: {
              count: past_delay_quantity,
              percent: past_delay_percentage.finite? ? past_delay_percentage : 0
            }
          },
          current_year => {
            total_count: current_total_quantity,
            total_percent: current_total_percentage.finite? ? current_total_percentage : 0,
            not_delay: {
              count: current_non_delay_quantity,
              percent: current_non_delay_percentage.finite? ? current_non_delay_percentage : 0
            },
            delay: {
              count: current_delay_quantity,
              percent: current_delay_percentage.finite? ? current_delay_percentage : 0
            }
          }
        }
      }
    end
  end
end
