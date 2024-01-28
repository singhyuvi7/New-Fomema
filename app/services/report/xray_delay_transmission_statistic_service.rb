# frozen_string_literal: true

module Report
  # Xray delay transmission statistic data
  class XrayDelayTransmissionStatisticService < DelayTransmissionStatistic
    def initialize(params)
      super(:xray, params)
    end

    private

    def filtered_transactions
      # query current and previous year
      Transaction
        .joins(:xray_examination)
        .includes(:doctor, :laboratory)
        .current_and_past_years
        .where.not(xray_transmit_date: nil)
        .where.not(xray_examinations: { xray_taken_date: nil })
        .transaction_date_between(@start_date, @end_date)
        .with_doctor_code(@doctor_code)
        .with_laboratory_code(@laboratory_code)
        .with_xray_code(@xray_code)
    end
  end
end
