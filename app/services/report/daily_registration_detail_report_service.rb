# frozen_string_literal: true

module Report
  # Daily & Monthly Registration Report with YTD report service
  class DailyRegistrationDetailReportService
    attr_reader :past_year_transactions, :current_year_transactions,
                :current_month_transactions, :branches,
								:past_year_certified_transactions, :current_year_certified_transactions, :current_month_certified_transactions

    def initialize(date)
      @date = format_date(date)
      @past_year_transactions = set_past_year_transactions
      @current_year_transactions = set_current_year_transactions
      @current_month_transactions = set_current_month_transactions
      # @pati_group_query = 'foreign_workers.pati is true and transactions.reg_ind. = 0'
      @pati_group_query = "foreign_workers.have_biodata is true and transactions.fw_maid_online = 'RTK'"
      @renewal_group_query = "CAST(nullif(transactions.fw_plks_number, '') AS integer) >= '1'"
      @past_year_certified_transactions = set_past_year_certified_transactions
			@current_year_certified_transactions = set_current_year_certified_transactions
      @current_month_certified_transactions = set_current_month_certified_transactions
    end

    def result
      [
        yearly_pati_group_count_for(past_year_transactions),
        yearly_pati_group_count_for(current_year_transactions),
        monthly_pati_group_count_for(current_year_transactions),
        daily_pati_group_count_for(current_month_transactions),
        combined_group_by_branches,
        branches,
        certified_yearly_pati_group_count_for(past_year_certified_transactions),
				certified_yearly_pati_group_count_for(current_year_certified_transactions),
        certified_monthly_pati_group_count_for(current_year_certified_transactions),
        certified_daily_pati_group_count_for(current_month_certified_transactions)
      ]
    end

    def valid?
      @date.present?
    end

    private

    def format_date(date)
      return date.to_date if date.is_a? String

      date
    end

    def set_past_year_transactions
      start_date = (@date - 1.year).beginning_of_year.to_date.to_s
      end_date = (@date - 1.year).end_of_year.to_date.to_s
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker)
        .transaction_date_between(start_date, end_date)
        .where.not(:status => ['CANCELLED','REJECTED'])
    end

    def set_current_year_transactions
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker)
        .where(transaction_date: @date.beginning_of_year...@date.end_of_day)
        .where.not(:status => ['CANCELLED','REJECTED'])
    end

    def set_current_month_transactions
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker)
        .where(transaction_date: @date.beginning_of_month...@date.end_of_day)
        .where.not(:status => ['CANCELLED','REJECTED'])
    end

    def transactions_by_date(date)
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker, :organization)
        .where(transaction_date: date.beginning_of_day...date.end_of_day)
        .where.not(:status => ['CANCELLED','REJECTED'])
    end

    def yearly_pati_group_count_for(transactions)
      transactions
        .select("#{@pati_group_query}, #{@renewal_group_query}")
        .group(@pati_group_query, @renewal_group_query)
        .count
        .transform_keys { |pati, renewal| [pati_key_mapping(pati), renewal_key_mapping(renewal)] }
    end

    def monthly_pati_group_count_for(transactions)
      transactions
        .select("date_trunc('month', transactions.transaction_date) as month, #{@pati_group_query}, #{@renewal_group_query}")
        .group("date_trunc('month', transactions.transaction_date)", @pati_group_query, @renewal_group_query)
        .count
        .transform_keys { |(date, pati, renewal)| [date.month, pati_key_mapping(pati), renewal_key_mapping(renewal)] }
    end

    def daily_pati_group_count_for(transactions)
      transactions
        .group('transactions.transaction_date::date', @pati_group_query, @renewal_group_query)
        .count
        .transform_keys { |(date, pati, renewal)| [date.to_date, pati_key_mapping(pati), renewal_key_mapping(renewal)] }
    end

    def group_by_branches(date)
      transactions_by_date(date)
        .group('organizations.name', @pati_group_query)
        .count
        .transform_keys { |(branch, pati)| [branch || '', pati_key_mapping(pati)] }
    end

    def pati_key_mapping(is_pati)
      is_pati ? :pati : :normal
    end

    def renewal_key_mapping(is_renewal)
      is_renewal ? :renewal : :new
    end

    def combined_group_by_branches
      # (T-7) = Same day last week
      # (T-1) = Day before
      # (T) = Current day
      {
        'T-7': group_by_branches(@date - 7.days),
        'T-1': group_by_branches(@date - 1.days),
        'T': group_by_branches(@date)
      }.tap do |hash|
        @branches = hash.values.map { |grouped_item| grouped_item.keys.map(&:first) }.flatten.uniq
      end
    end

    ## Certification
    def set_past_year_certified_transactions
      start_date = (@date - 1.year).beginning_of_year.to_date.to_s
      end_date = (@date - 1.year).end_of_year.to_date.to_s
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker)
        .certified_between(start_date, end_date)
    end

    def set_current_year_certified_transactions
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker)
        .where(certification_date: @date.beginning_of_year...@date.end_of_day)
    end

    def set_current_month_certified_transactions
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker)
        .where(certification_date: @date.beginning_of_month...@date.end_of_day)
    end

    def certified_transactions_by_date(date)
      Transaction
        .joins(:foreign_worker)
        .includes(:foreign_worker, :organization)
        .where(certification_date: date.beginning_of_day...date.end_of_day)
    end

    def certified_yearly_pati_group_count_for(transactions)
      transactions
        .group(@pati_group_query)
        .count
        .transform_keys { |key| pati_key_mapping(key) }
    end

    def certified_monthly_pati_group_count_for(transactions)
      transactions
        .select("date_trunc('month', transactions.certification_date) as month, #{@pati_group_query}")
        .group("date_trunc('month', transactions.certification_date)", @pati_group_query)
        .count
        .transform_keys { |(date, pati)| [date.month, pati_key_mapping(pati)] }
    end

    def certified_daily_pati_group_count_for(transactions)
      transactions
        .group('transactions.certification_date::date', @pati_group_query)
        .count
        .transform_keys { |(date, pati)| [date.to_date, pati_key_mapping(pati)] }
    end
  end
end
