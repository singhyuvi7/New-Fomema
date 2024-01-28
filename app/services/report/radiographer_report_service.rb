# frozen_string_literal: true

module Report
  # Radiographer receive, review and auto release report service
  class RadiographerReportService
    attr_reader :start_date, :end_date, :xqcc_pools, :xray_reviews_received, :xray_reviews_auto_released

    def initialize(start_date, end_date)
      @start_date = DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day
      @end_date = DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day
      @xqcc_pools = XqccPool.date_between(@start_date, @end_date)
      @xray_reviews_received = XrayReview.without_auto_release.transmitted_date_between(@start_date, @end_date)
      @xray_reviews_auto_released = XrayReview.with_auto_release.transmitted_date_between(@start_date, @end_date)
    end

    def result
      [data, date_by_day]
    end

    private

    def data
      {
        receive: receive_count_by_day,
        review: review_count_by_day,
        auto_release: auto_release_count_by_day,
      }
    end

    def receive_count_by_day
      xqcc_pools.group('created_at::date').count
    end

    def review_count_by_day
      xray_reviews_received.group('transmitted_at::date').count
    end

    def auto_release_count_by_day
      xray_reviews_auto_released.group('transmitted_at::date').count
    end

    def date_by_day
      (@start_date.to_date..@end_date.to_date).step(1).to_a
    end
  end
end
