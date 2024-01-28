# frozen_string_literal: true

module Report
  # Lab report for exporting
  class LaboratoryCertificationGenderStatisticService
    attr_reader :transactions

    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
      set_transactions
    end

    def result
      transaction_count_unique_keys
        .sort_by { |p| [p[2], p[1], p[0]] } # order by lab state, lab name, lab code
        .map { |row_data| [row_data, transaction_count.dig([*row_data, 'F']).to_i, transaction_count.dig([*row_data, 'M']).to_i].flatten }
    end

    private

    def set_transactions
      @transactions = filtered_transactions
    end

    def filtered_transactions
      Transaction
        .includes(:transaction_detail)
        .certified_between(@start_date, @end_date)
        .where.not(laboratory_transmit_date: nil)
        .where.not(transaction_details: { lab_code: nil })
        .where.not(transaction_details: { lab_name: nil })
    end

    def transaction_list
      @transactions
        .map { |transaction| transaction_mapping(transaction) }
        .delete_if { |data| data.all?(&:blank?) }
    end

    def transaction_mapping(transaction)
      %i[detail_lab_code detail_lab_name detail_lab_state_name fw_gender].map do |attribute|
        transaction.try(attribute) || ''
      end
    end

    def transaction_count(index: 0..-1)
      transaction_list
        .group_by { |transaction| transaction[index] }
        .map { |k, v| [k, v.size] }
        .to_h
    end

    def transaction_count_unique_keys
      transaction_count
        .keys
        .map { |a| a[0...-1] }
        .uniq
    end
  end
end
