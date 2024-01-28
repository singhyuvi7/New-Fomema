# frozen_string_literal: true

module Report
  # laboratory delay transmission statistic data
  class LaboratoryDelayTransmissionStatisticService < DelayTransmissionStatistic
    def initialize(params)
      super(:laboratory, params)
    end
  end
end
