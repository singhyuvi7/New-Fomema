# frozen_string_literal: true

module Report
  # Reporting for GP Unutilized Quota
  class DoctorUnutilizedQuotaService
    attr_reader :transactions

    def initialize(year, doc_codes, lab_codes, xray_codes)
      @doc_codes = doc_codes.reject(&:blank?)
      @lab_codes = lab_codes.reject(&:blank?)
      @xray_codes = xray_codes.reject(&:blank?)
      @year = year.to_i
      set_transactions
    end

    def result
      @transactions
    end

    private

    def set_transactions
      @transactions = scoped_transactions
    end

    def scoped_transactions
      Transaction
        .includes(:laboratory_examination, :fw_job_type, :fw_country, :xray_examination, :foreign_worker)
        .with_doctor_code(@doc_codes)
        .with_laboratory_code(@lab_codes)
        .with_xray_code(@xray_codes)
        .created_by_year(@year)
        .order(:created_at)
    end
  end
end
