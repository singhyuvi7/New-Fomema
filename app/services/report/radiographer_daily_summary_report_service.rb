# frozen_string_literal: true

module Report
  class RadiographerDailySummaryReportService
    attr_reader :xray_reviews

    def initialize(date, radiographer_id)
      @date = date.presence
      @radiographer_id = radiographer_id.presence
      @xray_reviews = set_xray_reviews
    end

    def valid?
      @date.present?
    end

    def result
      reviews_grouping
    end

    def reviews_grouping
      return {} unless @xray_reviews.present?

      @xray_reviews
        .group_by { |review| group_attributes(review) }
        .sort
        .map { |row_data| group_data_mapping(row_data) }
    end

    private

    def set_xray_reviews
      transmitted_xray_reviews
        .or(wrongly_transmitted_xray_reviews)
        .or(retake_xray_reviews)
    end

    def transmitted_xray_reviews
      XrayReview
        .includes(transactionz: %i[doctor xray_facility])
        .where(status: 'TRANSMITTED', radiographer_id: @radiographer_id)
        .by_transmitted_at_date(@date)
    end

    def wrongly_transmitted_xray_reviews
      XrayReview
        .includes(transactionz: %i[doctor xray_facility])
        .where(status: 'XQCC_REVIEW', result: 'WRONGLY_TRANSMITTED', radiographer_id: @radiographer_id)
        .by_transmitted_at_date(@date)
    end

    def retake_xray_reviews
      XrayReview
        .includes(transactionz: %i[doctor xray_facility])
        .where(status: 'XQCC_RETAKE', radiographer_id: @radiographer_id)
        .by_transmitted_at_date(@date)
    end

    def group_attributes(review)
      [
        review.batch_id.to_s,
        review.xray_facility_code.to_s,
        review.xray_facility_name.to_s
      ]
    end

    def group_data_mapping(row_data)
      # TODO: refactor codes in current methods
      # total_films, suspicious, identical, wrongly transmitted, normal, iqa,
      # others, compliance, non-compliance
      group_titles, group_data = row_data
      group_data_results = group_data.pluck(:result)

      total_films = group_data.size
      suspicious_count = group_data.count { |review| without_iqa?('SUSPICIOUS', review) }
      identical_count = group_data.count { |review| without_iqa?('IDENTICAL', review) }
      normal_count = group_data.count { |review| normal_without_iqa?(review) }
      wrong_transmission_count = group_data.count { |review| without_iqa?('WRONGLY_TRANSMITTED', review) }
      non_comply_count = group_data.count { |review| non_comply?(review) }
      comply_count = group_data.count { |review| !non_comply?(review) }
      [
        *group_titles,
        total_films,
        suspicious_count,
        identical_count,
        wrong_transmission_count,
        normal_count,
        group_data.pluck(:is_iqa).count('Y'),
        comply_count,
        non_comply_count
      ]
    end

    def normal_without_iqa?(review)
      # Once the case selected as IQA, the NORMAL count shall be null (redundant count since it is understand that only the NORMAL case will be selected as IQA)
      return false if review.is_iqa == 'Y'
      return false if %w[SUSPICIOUS IDENTICAL WRONGLY_TRANSMITTED].include?(review.result)

      true
    end

    def without_iqa?(status, review)
      return false if review.is_iqa == 'Y'
      # For image does not tick as Suspicious, Identical, Wrongly Transmitted,
      # and not selected as IQA, should count as Normal.

      review.result == status
    end

    def non_comply?(review)
      review.xray_review_details.any?
    end
  end
end
