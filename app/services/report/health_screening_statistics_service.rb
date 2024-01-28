# frozen_string_literal: true

module Report
  # Operation/Branch Foreign Worker Health Screening Statistic Report
  class HealthScreeningStatisticsService
    attr_reader :transactions, :total_count

    def initialize
      @total_count = {}
      @transactions = scoped_transactions
    end

    def result
      {
        sector: {
          total: count_by_sector,
          suitable: count_by_sector(filter: :suitable),
          unsuitable: count_by_sector(filter: :unsuitable),
        },
        state: {
          total: count_by_state,
          suitable: count_by_state(filter: :suitable),
          unsuitable: count_by_state(filter: :unsuitable)
        },
        origin: {
          total: count_by_origin,
          suitable: count_by_origin(filter: :suitable),
          unsuitable: count_by_origin(filter: :unsuitable)
        }
      }.then do |data|
        %i[sector state origin].map do |filter|
          [
            data.dig(filter, :total),
            data.dig(filter, :suitable),
            data.dig(filter, :unsuitable)
          ]
        end.then do |data_count|
          data_count << @total_count
        end
      end
    end

    private

    def scoped_transactions
      Transaction
        .joins(:foreign_worker, :fw_job_type)
        .where.not(final_result: nil)
    end

    def count_by_sector(filter: :all)
      transactions_filter_by(filter)
        .group(:fw_job_type_id, :registration_type)
        .count
        .transform_keys { |(id, status)| [JobType.find(id).name, status] }
        .tap { |data| total_count_mapping(:sector, filter, data) }
    end

    def count_by_state(filter: :all)
      transactions_filter_by(filter)
        .includes(foreign_worker: [employer: :state])
        .group_by { |transaction| [transaction.employer&.state&.name, transaction.registration_type] }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
        .tap { |data| total_count_mapping(:state, filter, data) }
    end

    def count_by_origin(filter: :all)
      transactions_filter_by(filter)
        .group(:fw_country_id, :registration_type)
        .count
        .transform_keys { |(id, status)| [Country.find(id).name, status] }
        .tap { |data| total_count_mapping(:origin, filter, data) }
    end

    def transactions_filter_by(filter = :all)
      case filter
      when :all
        @transactions
      when :suitable
        @transactions.where(final_result: 'SUITABLE')
      when :unsuitable
        @transactions.where(final_result: 'UNSUITABLE')
      end
    end

    def total_count_mapping(table, filter, data)
      {}.tap do |hash|
        %i[new renewal].each do |registration_type|
          hash[registration_type] = data.select { |key, _| key[1] == registration_type.to_s }.values.sum
        end
      end.then do |hash|
        @total_count[[table, filter]] = hash
      end
    end
  end
end
