# frozen_string_literal: true

module Report
  # Summary Transaction Expired Without Examination reporting service
  class SummaryTransactionExpiredWithoutExaminationService
    attr_reader :transactions

    def initialize(start_date, end_date, branch_id)
      @start_date = start_date + '+8'
      @end_date = end_date + '+8'
      @branch_id = branch_id
      @transactions = set_transactions
    end

    def result
      [transaction_grouping, grand_totals]
    end

    private

    def set_transactions
      return Transaction.none unless @start_date.present? && @end_date.present?

      Transaction
        .select("organization_id, sum(case when fw_gender = 'M' then 1 else 0 end) AS male_count, sum(case when fw_gender = 'F' then 1 else 0 end) AS female_count, expired_at::date, organization_id")
        .where('medical_examination_date is null and certification_date is null')
        .where.not(status: ['REJECTED', 'CANCELLED'])
        .where('expired_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .where('transaction_date >= ?', '2020-12-01 00:00:00')
        .search_organization(@branch_id)
        .joins(:organization)
        .group('expired_at::date, organization_id, organizations.name')
        .order('organizations.name ASC, expired_at ASC')
    end

    def transaction_grouping
      @transaction_grouping ||=
        transactions
        .map { |transaction| transaction_mapping(transaction) }
        .group_by { |data| data[1] }
        .transform_values { |items| gender_count_remapping(items) }
    end

    def transaction_mapping(transaction)
      [
        transaction.expired_at.try(:strftime, '%d/%m/%Y'),
        transaction.organization_name,
        transaction.male_count,
        transaction.female_count,
        transaction.organization_id,
      ]
    end

    def grand_totals
      total_male_count = transactions.map(&:male_count).sum
      total_female_count = transactions.map(&:female_count).sum

      [].tap do |grand_total|
        grand_total << total_male_count
        grand_total << total_female_count
        grand_total << [total_male_count, total_female_count].sum
      end.then { |grand_totals| @grand_totals ||= grand_totals }
    end

    def gender_count_remapping(items)
      [].tap do |list|
        items.each do |item|
          list << [item[0], item[1], 'Male', item[2], "M", item[4]]
          list << [item[0], item[1], 'Female', item[3], "F", item[4]]
        end
      end
    end

    def grand_total_gender_count_mapping(transactions)
      total_male_count = transaction.pluck(:male_count).sum
      total_female_count = transactions.pluck(:female_count).sum
      total_count = [total_male_count, total_female_count].sum

      [total_male_count, total_female_count, total_count]
    end
  end
end
