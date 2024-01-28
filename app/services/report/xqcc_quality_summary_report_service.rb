# frozen_string_literal: true

module Report
  # XQCC quality summary report service (analog and digital)
  class XqccQualitySummaryReportService
    attr_reader :xray_reviews, :xray_examinations, :xray_dispatch_items, :xray_facility, :non_comply_data, :xqcc_data, :stats, :film_type

    ANALOG_ATTRIBUTES =
      Psych
      .load_file(Rails.root.join('lib', 'seeds', 'xray', 'non_comply_sum_titles.yaml'))
      .with_indifferent_access
      .dig(:analog)
      .each_with_object({}) { |(k, v), h| h[k] = v.keys }
      .freeze

    DIGITAL_ATTRIBUTES =
      Psych
      .load_file(Rails.root.join('lib', 'seeds', 'xray', 'non_comply_sum_titles.yaml'))
      .with_indifferent_access
      .dig(:digital)
      .each_with_object({}) { |(k, v), h| h[k] = v.keys }
      .freeze

    NON_COMPLY_CODES_ANALOG =
      Psych
      .load_file(Rails.root.join('lib', 'seeds', 'xray', 'non_comply_codes_analog.yaml'))
      .invert
      .with_indifferent_access
      .freeze

    NON_COMPLY_CODES_DIGITAL =
      Psych
      .load_file(Rails.root.join('lib', 'seeds', 'xray', 'non_comply_codes_digital.yaml'))
      .invert
      .with_indifferent_access
      .freeze

    NON_COMPLY_SUM_TITLES =
      Psych
      .load_file(Rails.root.join('lib', 'seeds', 'xray', 'non_comply_sum_titles.yaml'))
      .with_indifferent_access
      .freeze

    XQCC_SUM_TITLES = {
      analog: {
        suspicious: 'Sum of SUS',
        iqa: 'Sum of IQA',
        nc_film: 'Sum of NC Films',
        view_film: 'Sum of Viewed Films'
      },
      digital: {
        suspicious: 'Sum of SUS',
        identical: 'Sum of Identical',
        wrong_transmission: 'Sum of Wrongly Transmitted',
        iqa: 'Sum of IQA',
        nc_film: 'Sum of NC Films',
        view_film: 'Sum of Viewed Films',
        retake: 'Sum of Retake',
        others: 'Others',
      }

    }.freeze


    MERTS_SUM_TITLES = {
      analog: {
        nc_film: 'Sum of NC Films',
        view_film: 'Sum of Viewed Films'
      },
      digital: {
        nc_film: 'Sum of NC Films',
        view_film: 'Sum of Viewed Films',
      }

    }.freeze

    def initialize(xray_code, year, film_type)
      @xray_code = xray_code
      @year = year.to_i
      @film_type = film_type.to_sym
      @xray_reviews = set_xray_reviews
      @xray_examinations = set_xray_examinations
      @xray_dispatch_items = set_xray_dispatch_items
      @xray_facility = XrayFacility.find_by(code: @xray_code)
      @non_comply_data = initialize_non_comply_data
      @xqcc_data = initialize_xqcc_data
      @stats = initialize_stats_data
      @xray_retakes = set_xray_retakes
    end

    def result
      group_by_month_and_calculation
      retake_group_by_month_and_calculation
    end

    def valid?
      @year.present? && @xray_facility.present?
    end

    private

    def set_xray_reviews
      XrayReview
        .send(@film_type)
        .includes(:xray_review_details)
        .with_xray_code(@xray_code)
        .with_transmitted_at_year(@year)
    end

    def set_xray_retakes
      XrayRetake
        .send(@film_type)
        .with_xray_code(@xray_code)
        .with_created_at_year(@year)
    end

    def set_xray_examinations
      XrayExamination
        .send(@film_type)
        .with_xray_code(@xray_code)
        .with_created_at_year(@year)
        .where(sourceable_type: 'Transaction')
        .done
    end

    def set_xray_dispatch_items
      XrayDispatchItem
        .send(@film_type)
        .with_xray_code(@xray_code)
        .with_created_at_year(@year)
    end

    def group_by_month_and_calculation
      return {} unless @xray_reviews.present?

      @xray_reviews
        .search_status('REVIEWED')
        .tap { |reviews| @viewed_xray_reviews = reviews }
        .tap { |reviews| reported_by_stats_mapping(reviews) }
        .tap { |reviews| sop_stats_mapping(reviews) }
        .group_by { |review| review.created_at.month }
        .tap { |group_collection| non_comply_data_mapping(group_collection) }
        .tap { |group_collection| xqcc_data_mapping(group_collection) }
        .tap { stats_data_mapping }
    end

    def retake_group_by_month_and_calculation
      return {} unless @xray_retakes.present?

      @xray_retakes
        .where(requestable_type: ['XrayReview', 'PcrReview'])
        .group_by { |retake| retake.created_at.month }
        .tap { |group_collection| xqcc_retake_data_mapping(group_collection) }
    end

    def initialize_non_comply_data
      {
        analog: initialize_analog_non_comply_data,
        digital: initialize_digital_non_comply_data
      }
    end

    def initialize_analog_non_comply_data
      return {} unless @film_type == :analog

      Array.new(12) do
        {
          id: Hash.new { 0 },
          processing_procedures: Hash.new { 0 },
          positioning_techniques: Hash.new { 0 },
          exposure_factors: Hash.new { 0 },
          artifacts: Hash.new { 0 },
          superimposed: Hash.new { 0 },
          primary_anatomical_marker: Hash.new { 0 },
          blur: Hash.new { 0 },
          others: Hash.new { 0 },
          xqcc: Hash.new { 0 }
        }
      end
    end

    def initialize_digital_non_comply_data
      return unless @film_type == :digital

      Array.new(12) do
        {
          id: Hash.new { 0 },
          positioning_techniques: Hash.new { 0 },
          exposure_factors: Hash.new { 0 },
          artifacts: Hash.new { 0 },
          superimposed: Hash.new { 0 },
          primary_anatomical_marker: Hash.new { 0 },
          blur: Hash.new { 0 },
          others: Hash.new { 0 },
          xqcc: Hash.new { 0 }
        }
      end
    end

    def initialize_xqcc_data
      {
        analog: Array.new(12) { Hash.new { 0 } },
        digital: Array.new(12) { Hash.new { 0 } }
      }
    end

    def initialize_stats_data
      {
        analog: Hash.new { 0 },
        digital: Hash.new { 0 }
      }
    end

    def non_comply_data_mapping(group_collection)
      group_collection.map do |month, collection|
        next if collection.blank?

        collection.each do |xray_review|
          self.class.const_get("#{film_type.to_s.upcase}_ATTRIBUTES").each do |key, attributes|
            attributes.each do |attribute|
              if xray_review.get_condition_detail(self.class.const_get("NON_COMPLY_CODES_#{@film_type.to_s.upcase}")[attribute].to_s) == 'Y'
                @non_comply_data[film_type][month - 1][key.to_sym][attribute.to_sym] += 1
              end
            end
          end
        end
      end
    end

    def xqcc_data_mapping(group_collection)
      group_collection.map do |month, collection|
        next if collection.blank?

        index = month - 1
        @xqcc_data[film_type][index][:suspicious] = count_suspicious(collection)
        @xqcc_data[film_type][index][:iqa] = count_iqa(collection)
        @xqcc_data[film_type][index][:nc_film] = count_nc_film(collection)
        @xqcc_data[film_type][index][:view_film] = count_view_film(collection)
        @xqcc_data[film_type][index][:identical] = count_identical(collection)
        @xqcc_data[film_type][index][:wrong_transmission] = count_wrong_transmission(collection)
        @xqcc_data[film_type][index][:others] = count_others(collection)
      end
    end

    def xqcc_retake_data_mapping(group_collection)
      group_collection.map do |month, collection|
        next if collection.blank?

        index = month - 1
        @xqcc_data[film_type][index][:retake] = count_retake(collection)
      end
    end

    def count_suspicious(collection)
      collection.map(&:result).count('SUSPICIOUS')
    end

    def count_iqa(collection)
      collection.map(&:is_iqa).count('Y')
    end

    def count_nc_film(collection)
      collection.map(&:non_comply?).count(true)
    end

    def count_view_film(collection)
      collection.size
    end

    def count_identical(collection)
      collection.map(&:result).count('IDENTICAL')
    end

    def count_wrong_transmission(collection)
      collection.map(&:result).count('WRONG_TRANSMISSION')
    end

    def count_others(collection)
      collection.map(&:result).compact.count { |result| !result.in?(%w[NORMAL SUSPICIOUS IDENTICAL WRONG_TRANSMISSION]) }
    end

    def count_retake(collection)
      collection.map(&:approval_decision).count('APPROVE')
    end

    def reported_by_stats_mapping(reviews)
      reviews
        .tap { |resources| stats_mapping(resources) }
    end

    def stats_mapping(resources)
      resources
        .map(&:reported_by)
        .tap { |data| @stats[film_type][:reported_by_gp] = data.count('G') }
        .tap { |data| @stats[film_type][:reported_by_cr] = data.count('C') }
    end

    def sop_stats_mapping(reviews)
      @stats[film_type][:sop_comply] = reviews.map(&:comply?).count(true)
      @stats[film_type][:sop_non_comply] = reviews.map(&:non_comply?).count(true)
    end

    def stats_data_mapping
      self.class.const_get("#{film_type.to_s.upcase}_ATTRIBUTES").keys.map(&:to_sym).each do |key|
        @stats[film_type][key] = @non_comply_data[film_type].pluck(key).map(&:values).flatten.compact.sum
      end
      @stats[film_type][:total_viewed] = @viewed_xray_reviews.send(film_type).size
      if @stats[film_type][:total_viewed]
        @stats[film_type][:sop_comply_percent] = (@stats[film_type][:sop_comply].to_f / @stats[film_type][:total_viewed].to_f) * 100
        @stats[film_type][:sop_non_comply_percent] = (@stats[film_type][:sop_non_comply].to_f / @stats[film_type][:total_viewed].to_f) * 100
      end
      @stats[film_type][:xray_submitted] = xray_submitted_count
      @stats[film_type][:xray_viewed] = xray_viewed_count
      @stats[film_type][:xray_pending_view] = xray_pending_view_count
    end

    # digital
    # select
    # count(case when batch_id is not null and TO_CHAR(PICKUP_DATE,'yyyy')=$P{xqccdate} then 1 end) as "Submitted",
    # count(case when batch_id is null then 1 end) as "Outstanding",
    # count(1) as "total"
    # from DXBASKET
    # where ($P{xraycode} is null or XRAY_CODE=$P{xraycode}

    def xray_submitted_count
      # digital: total xray submited by xray facilites
      # analog: total xray submited by xray facilites to FOMEMA

      xray_reviews.where.not(batch_id: nil).size
    end

    def xray_viewed_count
      # digital: total xray view by radiographer(FOMEMA) where GP already certified
      # analog: Total receive by FOMEMA where GP already certified
      return @viewed_xray_reviews.size if film_type == :digital

      xray_dispatch_items.gp_certified.size
    end

    def xray_pending_view_count
      # digital: total pending view by radiographer(FOMEMA) where GP already certified
      # analog: X-Ray Done - Submitted
      return(xray_submitted_count - xray_viewed_count) if film_type == :digital

      xray_dispatch_items.pending_gp_certified.size
    end
  end
end
