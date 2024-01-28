# frozen_string_literal: true

module Report
  # Daily branch registration report service
  class DailyBranchRegistrationReportService
    attr_reader :transactions, :headers, :date, :certification_headers, :certifications

    def initialize(date)
      @date = format_date(date)
      @headers = ['REGISTRATION DATE', 'REGIONAL OFFICE', 'COUNT OF EMPLOYERS', '%', 'NORMAL', 'REKAB', 'TOTAL FOREIGN WORKERS', '%']
      @transactions = set_transactions
      @certification_headers = ['CERTIFICATION DATE', 'NORMAL', 'REKAB', 'TOTAL', '%']
      @certifications = set_certifications
    end

    def result
      [
        transaction_group_count,
        certification_group_count,
        headers,
        certification_headers
      ]
    end

    def valid?
      @date.present?
    end

    private

    def transaction_group_count
      @transactions
        .group_by { |transaction| group_attributes(transaction) }
        .map { |(keys, collection)| [keys, registration_counts(collection)].flatten }
        .sort
        # .tap { |registrations| append_total_count_for(registrations) }
    end

    def set_transactions
      Transaction
        .transaction_date_between(@date, @date)
        .where.not(:status => ['CANCELLED','REJECTED'])
    end

    def format_date(date)
      return date.to_date.to_s if date.is_a? DateTime
      return date.to_date.to_s if date.is_a? ActiveSupport::TimeWithZone
      return date.to_s if date.is_a? Date

      date
    end

    def group_attributes(transaction)
      [
        transaction.transaction_date.strftime('%d-%^b-%y'),
        if transaction.agency_id.blank?
          transaction.organization.name
        else
          'AGENCY'
        end
      ]
    end

    def registration_counts(collection)
      normal_count = collection.map { |transaction| pati_registration?(transaction) }.count(false)
      rekab_count = collection.map { |transaction| pati_registration?(transaction) }.count(true)

      [].tap do |array|
        array << collection.map { |transaction| transaction.employer_id }.uniq.count
        array << collection.map { |transaction| pati_registration?(transaction) }.count(false)
        # array << '%.2f' % ((normal_count * 100) / collection.size.to_f) # normal / Total reg at branch
        array << collection.map { |transaction| pati_registration?(transaction) }.count(true)
        # array << '%.2f' % ((rekab_count * 100) / collection.size.to_f) # rekab / Total reg at branch
        array << collection.size
        array << '%.2f' % ((collection.size * 100) / transactions.size.to_f) # Total reg at branch / total reg per day
      end
    end

    def pati_registration?(transaction)
      # case when fw.pati=true and t.reg_ind=0 then 1 else 0 end
      # transaction.foreign_worker_pati && transaction.reg_ind&.zero?
      transaction.foreign_worker.have_biodata && transaction.fw_maid_online == 'RTK'
    end

    def append_total_count_for(registrations)
      registrations
        .map { |row_data| row_data[2..-1] }
        .tap do |collection_count|
          total_sum = [nil, 'Total', *collection_count.transpose.map(&:sum)]
          total_sum[4] = '100.00'
          registrations << total_sum
        end
    end

    ## Certification
    def certification_group_count
      @certifications
        .group_by { |transaction| certification_group_attributes(transaction) }
        .map { |(keys, collection)| [keys, certification_counts(collection)].flatten }
        .sort
    end

    def set_certifications
      Transaction
        .certified_between(@date, @date)
    end

    def certification_group_attributes(transaction)
      [
        transaction.certification_date.strftime('%d-%^b-%y')
      ]
    end

    def certification_counts(collection)
      normal_count = collection.map { |transaction| pati_registration?(transaction) }.count(false)
      rekab_count = collection.map { |transaction| pati_registration?(transaction) }.count(true)
      [].tap do |array|
        array << collection.map { |transaction| pati_registration?(transaction) }.count(false)
        # array << '%.2f' % ((normal_count * 100) / collection.size.to_f) # normal / total certification
        array << collection.map { |transaction| pati_registration?(transaction) }.count(true)
        # array << '%.2f' % ((rekab_count * 100) / collection.size.to_f) # rekab / total certification
        array << collection.size
        array << '%.2f' % ((collection.size * 100) / certifications.size.to_f) # Total reg at branch / total reg per day
      end
    end
  end
end
