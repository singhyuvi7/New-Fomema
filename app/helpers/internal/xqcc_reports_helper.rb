# frozen_string_literal: true

module Internal
  # xqcc report helper
  module XqccReportsHelper
    def all_months(year)
      (1..12).map { |month| Date.new(year, month).strftime('%b/%y') }
    end
  end
end
