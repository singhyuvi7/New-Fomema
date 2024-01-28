# frozen_string_literal: true

module Report
  # Operation Monthly registration report by job type
  class MonthlyRegistrationByJobTypeService
    attr_reader :transactions, :job_type_count, :branch_count

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
      @date_range = DateTime.new(@year, @month).beginning_of_month..DateTime.new(@year, @month).end_of_month
      @branches = Organization.order(:name).pluck(:id, :name)
      @job_types = JobType.order(:name).pluck(:id, :name)
      @transactions = scoped_transactions
    end

    def result
      [
        @branches,
        @job_types,
        branch_job_type_count,
        transaction_organization_count
      ]
    end

    private

    def branch_job_type_count
      @job_type_count =
        @transactions
        .group_by { |transaction| [transaction.organization_id, transaction.fw_job_type_id] }
        .each_with_object({}) { |(key, value), hash| hash[key] = value.size }
    end

    def transaction_organization_count
      @branch_count =
        @transactions
        .group_by(&:organization_id)
        .each_with_object({}) { |(key, value), hash| hash[key] = value.size }
    end

    def scoped_transactions
      Transaction
        .where(created_at: @date_range)
        .where.not(organization_id: nil)
    end
  end
end
