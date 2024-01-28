# frozen_string_literal: true

module Report
  # MCLX report service for exporting
  class MclxReportService
    non_compliances = Psych.load_file(Rails.root.join('lib', 'seeds', 'xray', 'non_comply.yaml'))
    ANALOG_NON_COMPLY = non_compliances['analog'].map(&:to_sym).freeze
    DIGITAL_NON_COMPLY = non_compliances['digital'].map(&:to_sym).freeze
    ALL_NON_COMPLY = ANALOG_NON_COMPLY.dup.concat(DIGITAL_NON_COMPLY.dup).freeze

    def initialize
      @date_range = DateTime.current.beginning_of_year..DateTime.current.end_of_year
    end

    def result
      {
        analog: {
          total_submission: total_submission(:analog),
          total_view: total_view(:analog),
          total_view_by_gp: total_view_by_gp(:analog),
          total_view_by_cr: total_view_by_cr(:analog),
          total_non_comply: total_non_comply(:analog),
          total_non_comply_detail: total_non_comply_detail(:analog)
        },
        digital: {
          total_submission: total_submission(:digital),
          total_view: total_view(:digital),
          total_view_by_gp: total_view_by_gp(:digital),
          total_view_by_cr: total_view_by_cr(:digital),
          total_non_comply: total_non_comply(:digital),
          total_non_comply_detail: total_non_comply_detail(:digital)
        }
      }
    end

    private

    def total_submission(type)
      # count digital xqcc pool or analog xray examinations records by xray facility code
      resources = type == :digital ? scoped_xqcc_pools(type) : scoped_xray_examinations(type)
      resources
        .joins(transactionz: %i[xray_facility])
        .where(created_at: @date_range)
        .group_by { |resource| type == :digital ? resource.transactionz.xray_facility.code : [resource.transactionz.xray_facility.code, resource.transactionz.xray_facility.name] }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
    end

    def total_view(type)
      # count analog/digital xray review records by xray facility code
      scoped_xray_reviews(type)
        .joins(transactionz: %i[xray_facility])
        .where(created_at: @date_range)
        .group_by { |pool| type == :digital ? pool.transactionz.xray_facility.code : [pool.transactionz.xray_facility.code, pool.transactionz.xray_facility.name] }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
    end

    def total_view_by_gp(type)
      # count analog/digital xray review records where radiologist = nil
      # and group by xray facility code
      scoped_xray_reviews(type)
        .joins(transactionz: %i[xray_facility])
        .where(created_at: @date_range)
        .without_radiologist
        .group_by { |pool| type == :digital ? pool.transactionz.xray_facility.code : [pool.transactionz.xray_facility.code, pool.transactionz.xray_facility.name] }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
    end

    def total_view_by_cr(type)
      # count analog/digital xray review records with radiologist
      # and group by xray facility code
      scoped_xray_reviews(type)
        .joins(transactionz: %i[xray_facility])
        .where(created_at: @date_range)
        .with_radiologist
        .group_by { |pool| type == :digital ? pool.transactionz.xray_facility.code : [pool.transactionz.xray_facility.code, pool.transactionz.xray_facility.name] }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
    end

    def total_non_comply(type)
      # count analog/digital non-comply xray review records
      # and group by xray code
      scoped_xray_reviews(type)
        .joins(transactionz: %i[xray_facility])
        .where(created_at: @date_range)
        .select(&:non_comply?)
        .group_by { |pool| type == :digital ? pool.transactionz.xray_facility.code : [pool.transactionz.xray_facility.code, pool.transactionz.xray_facility.name] }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
    end

    def total_non_comply_detail(type)
      # count analog/digital non-comply xray review records
      # and group by xray code and non-comply attribute
      scoped_xray_reviews(type)
        .joins(transactionz: %i[xray_facility])
        .where(created_at: @date_range)
        .select(&:non_comply?)
        .each_with_object([]) { |review, result| review.tap { |record| insert_to_object(result, record) } }
        .group_by { |list| list }
        .each_with_object({}) { |grouped_item, hash| hash[grouped_item[0]] = grouped_item[1].size }
    end

    def scoped_xqcc_pools(type)
      return XqccPool.analog if type == :analog
      return XqccPool.digital if type == :digital

      XqccPool
    end

    def scoped_xray_reviews(type)
      return XrayReview.analog if type == :analog
      return XrayReview.digital if type == :digital

      XrayReview
    end

    def scoped_xray_examinations(type)
      return XrayExamination.analog if type == :analog
      return XrayExamination.digital if type == :digital

      XrayExamination
    end

    def insert_to_object(result, review)
      review.non_comply.each do |attribute, value|
        date = review.review_date&.strftime('%m/%d/%Y')
        xray_code = review.transactionz.xray_facility.code
        xray_name = review.transactionz.xray_facility.name
        result << [date, xray_code, xray_name, attribute] if value == 'Y'
      end
    end
  end
end
