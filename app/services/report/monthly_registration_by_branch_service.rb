# frozen_string_literal: true

module Report
  # monthly registration by branch report
  class MonthlyRegistrationByBranchService
    attr_reader :transactions

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
      @date_range = DateTime.new(@year, @month).beginning_of_month..DateTime.new(@year, @month).end_of_month
      @transactions = scoped_transactions
      @branch_codes = @transactions.map(&:organization_code).compact.uniq.sort
    end

    def result
      [slot_data, total_count]
    end

    private

    def registration_count_by_branch
      @registration_count_by_branch ||=
        @transactions
        .decorate
        .group_by { |transaction| [transaction.organization_code, transaction.renewal?] }
        .each_with_object({}) { |(key, value), hash| hash[key] = value.size }
    end

    def scoped_transactions
      Transaction
        .includes(:organization)
        .where(created_at: @date_range)
        .where.not(organization_id: nil)
    end

    def slot_data
      @slot_data ||=
        @branch_codes.map do |code|
          new_count = registration_count_by_branch.dig([code, 'NEW']) || 0
          renewal_count = registration_count_by_branch.dig([code, 'RENEWAL']) || 0
          [code, new_count, renewal_count, new_count + renewal_count]
        end
    end

    def total_count
      slot_data
        .map { |row_data| row_data[1..-1] }
        .then do |data|
          data.delete_at(0).zip(*data)
        end
        .map(&:sum)
    end
  end
end
