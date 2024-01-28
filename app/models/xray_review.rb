class XrayReview < ApplicationRecord
    STATUSES = {
        "XQCC_REVIEW" => "XQCC REVIEW",
        "XQCC_RETAKE" => "XQCC RETAKE",
        "XQCC_ABORT" => "XQCC ABORT",
        "TRANSMITTED" => "TRANSMITTED",
    }

    RESULTS = {
        "NORMAL" => "NORMAL",
        "SUSPICIOUS" => "SUSPICIOUS",
        "IDENTICAL" => "IDENTICAL",
        "WRONGLY_TRANSMITTED" => "WRONGLY TRANSMITTED",
        "RETAKE" => "RETAKE",
        "ABORT" => "ABORT",
        #"WRONG_TRANSMISSION" => "WRONG TRANSMISSION", # seems not using
    }

    CASE_TYPES = {
        "XRAY_EXAMINATION_NORMAL" => "XRAY EXAMINATION: NORMAL",
        "XQCC_PENDING_REVIEW_XQCC_POOL" => "XQCC PENDING REVIEW: RADIOGRAPHER REVIEW",
    }

    IS_IQAS = {
        "Y" => "Yes",
        "N" => "No"
    }

    CONDITION_DETAILS = {
        "6101" => "ID - Incomplete", #"is_id_incomplete",
        "6133" => "ID - Incomplete - Clinic Name", #"id_incomplete_clinic_name", #new
        "6134" => "ID - Incomplete - Worker Name", #"id_incomplete_worker_name", #new
        "6135" => "ID - Incomplete - Transaction ID", #"id_incomplete_transaction_id", #new
        "6136" => "ID - Incomplete - X-Ray Taken Date", #"id_incomplete_xray_taken_date", #new

        "6128" => "ID - Wrong", #"is_id_wrong",
        "6137" => "ID - Wrong - Clinic Name", #"id_wrong_clinic_name", #new
        "6138" => "ID - Wrong - Worker Name", #"id_wrong_worker_name", #new
        "6139" => "ID - Wrong - Transaction ID", #"id_wrong_transaction_id", #new
        "6140" => "ID - Wrong - X-Ray Taken Date", #"id_wrong_xray_taken_date", #new

        "6141" => "Positioning Technique - ROI Cut Off", #"is_pos_roi_cut_off", #new
        "6110" => "Positioning Technique - ROI Cut Off - Apices cut", #"pos_apices_cut",
        "6111" => "Positioning Technique - ROI Cut Off - Chest wall cut", #"pos_chest_wall_cut",
        "6112" => "Positioning Technique - ROI Cut Off - CPA cut", #"pos_cpa_cut",

        "6113" => "Positioning Technique - ROI not clearly visualized", #"is_pos_roi_not_clearly_visualized", #new
        "6142" => "Positioning Technique - ROI not clearly visualized - Rotation", #"pos_rotation", #new
        "6143" => "Positioning Technique - ROI not clearly visualized - Angulation", #"pos_angulation", #new
        "6144" => "Positioning Technique - ROI not clearly visualized - ID/Flashing obscuring apex", #"pos_id_obscure_apex",

        "6115" => "Positioning Technique - Collimation", #"is_pos_collimation"
        "6145" => "Positioning Technique - Collimation - Poor collimation", #"pos_poor_colimation", #new
        "6146" => "Positioning Technique - Collimation - No Collimation", #"pos_no_colimation", #new

        "6109" => "Positioning Technique - Scapular not retracted", #"is_pos_scapular_not_retracted",
        "6120" => "Positioning Technique - Poor Inspiratory Effort", #"is_pos_poor_inspiratory_effort",

        "6116" => "Positioning Technique - Marker obscuring apex", #"pos_marker_obscure_apex",
        "6117" => "Exposure factors - Over-Exposed", #"is_exp_overexposure",
        "6118" => "Exposure factors - Under-Exposed", #"is_exp_underexposure",
        "6119" => "Artifacts - Processing Artifacts", #"is_arti_processing_artifacts",
        "6131" => "Artifacts - Poor Handling Artifacts", #"is_arti_poor_handling_artifacts", #new
        "6147" => "Superimposed - Same thoracic cage", #"is_super_same_thoracic_cage", #new
        "6148" => "Superimposed - Different thoracic cage", #"is_super_different_thoracic_cage", #new

        "6149" => "Primary Anatomical Marker - Wrong Placement", #"is_pam_wrong_placement", #new
        "6150" => "Primary Anatomical Marker - Not Available", #"is_pam_not_available", #new

        "6121" => "Blur - Movement", #"is_blur_movement",
        "6132" => "Blur - Breathing", #"is_blur_breathing", #new

        "6130" => "Improper Report", #"is_improper_report", #analog
        "6151" => "No Diagnostic Value", #"is_no_diagnostic_value", #new

        "6102" => "ID - Not Clear", #"is_id_not_clear"
        "6152" => "ID - Not Clear - Blur", #"id_not_clear_blur", #new
        "6153" => "ID - Not Clear - Fog", #"id_not_clear_fog", #new
        "6154" => "ID - Not Clear - Dark", #"id_not_clear_dark", #new

        "6103" => "ID - Not Printed", #"is_id_not_printed"
        "6155" => "ID - Not Printed - Handwritten", #"id_not_printed_handwritten", #new
        "6156" => "ID - Not Printed - Sticker", #"id_not_printed_sticker", #new

        "6104" => "Processing Procedure - Chemical Defect", #"is_proc_chemical_defect"
        "6157" => "Processing Procedure - Chemical Defect - Weak Chemical", #"proc_chemical_defect_weak_chemical"
        "6158" => "Processing Procedure - Chemical Defect - Discoloration", #"proc_chemical_defect_discoloration"
        "6159" => "Processing Procedure - Chemical Defect - Stain", #"proc_chemical_defect_stain"
        "6160" => "Processing Procedure - Chemical Defect - Water Mark", #"proc_chemical_defect_water_mark"
        "6105" => "Processing Procedure - Chemical Defect - Poor Agitation", #"proc_chemical_defect_poor_agitation"

        "6106" => "Processing Procedure - Marks of Film", #"is_proc_marks_of_film",
        "6161" => "Processing Procedure - Marks of Film - Film Guide Mark", #"proc_marks_of_film_film_guide_mark", #new
        "6162" => "Processing Procedure - Marks of Film - Scratches", #"proc_marks_of_film_scratches", #new

        "6107" => "Processing Procedure - Fogged", #"is_proc_fog", # obsolete
        "6163" => "Processing Procedure - Partial Fog", #"proc_fog_partial_fog", # obsolete
        "6164" => "Processing Procedure - Base Fog", #"proc_fog_base_fog", # obsolete

        "6108" => "Processing Procedure - Screen Defect", #"is_proc_screen_defect"
        "6165" => "Processing Procedure - Screen Defect - Dirty Screen", #"proc_screen_defect_dirty_screen", # new
        "6166" => "Processing Procedure - Screen Defect - Spoilt Screen", #"proc_screen_defect_spoilt_screen", # new

        "6125" => "Taken By Indicator", #"taken_by", #no data
        "6126" => "Reported By Indicator", #"reported_by", #no data

        "6122" => "Marker Problem", #"is_marker_problem", #obsolete
        "6123" => "Report Problem", #obsolete
        "6124" => "Envelopes Problem", #"is_envelope_problem",
        "6127" => "ID - Not Available", #"is_id_not_available", # obsolete
        "6129" => "Improper Marking", #"is_improper_marking", # obsolete
=begin
"6101"	2027
"6102"	14574
"6103"	8389
"6104"	26764
"6105"	1190
"6106"	14656
"6107"	2230
"6108"	7027
"6109"	12524
"6110"	482
"6111"	642
"6112"	859
"6113"	37
"6115"	6164
"6116"	183
"6117"	1237
"6118"	355
"6119"	19932
"6120"	6092
"6121"	399
"6122"	2275
"6123"	10618
"6124"	4443
"6125"	813103	"C" 5147265	"G"
"6126"	2078346	"C" 3882022	"G"
"6127"	7
"6128"	240
"6129"	1491
"6130"	22
=end
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include XrayRetakeRequest
    include ParentTransactionScope
    include OrderScope
    include XrayMovement

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :radiographer, :class_name => :User, :foreign_key => "radiographer_id", optional: true
    belongs_to :poolable, polymorphic: true, optional: true

    has_one :foreign_worker, through: :transactionz
    has_one :pcr_review, through: :transactionz
    has_one :xray_pending_review, through: :transactionz
    has_one :xray_pending_decision, through: :transactionz
    has_one :xray_retake, through: :transactionz

    has_many :xqcc_review_identicals
    has_many :xray_retakes, as: :requestable
    has_one :xray_retake, as: :requestable
    has_many :xqcc_comments, as: :commentable
    has_many :xray_review_details

    delegate :xray_test_done_date, :detail_xray_code, :xray_facility_name, :xray_facility_code,
             to: :transactionz, allow_nil: true

    # scopes
    scope :latest_record, -> {
        joins(:transactionz).where("transactions.xray_review_id = xray_reviews.id")
    }

    scope :by_transmitted_at_date, ->(date) { where(transmitted_at: DateTime.parse(date).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(date).in_time_zone('Kuala Lumpur').end_of_day) }

    scope :transmitted_date_between, ->(start_date, end_date) { where(transmitted_at: start_date..end_date) }

    scope :with_auto_release, lambda {
        # For auto release count
        # auto release nios user = Nios::UserMaster.find_by(uuid: 9999)
        user = User.system_user

        user ? where(radiographer_id: user.id) : XrayReview.none
    }

    scope :without_auto_release, lambda {
        # For review count.
        # auto release nios user = Nios::UserMaster.find_by(uuid: 9999)
        user = User.system_user

        where.not(radiographer_id: user.id) if user
    }

    scope :search_status, -> (review_status) {
        case review_status
        when 'ASSIGN'
            where(status: 'XQCC_REVIEW')

        when 'REVIEWED'
            where.not(status: 'XQCC_REVIEW')

        when 'REVIEWED_NORMAL'
            where(result: 'NORMAL')
            .where.not(status: 'XQCC_REVIEW')

        when 'REVIEWED_SUSPICIOUS'
            where(result: 'SUSPICIOUS')
            .where.not(status: 'XQCC_REVIEW')

        when 'REVIEWED_IDENTICAL'
            where(result: 'IDENTICAL')
            .where.not(status: 'XQCC_REVIEW')

        when 'REVIEWED_WRONGLY_TRANSMITTED'
            where(result: 'WRONGLY_TRANSMITTED')
            .where.not(status: 'XQCC_REVIEW')

        when 'REVIEWED_RETAKE'
            where(result: 'RETAKE')
            .where.not(status: 'XQCC_REVIEW')

        when 'REVIEWED_ABORT'
            where(result: 'ABORT')
            .where.not(status: 'XQCC_REVIEW')

        when 'ALL'

        else
            where(status: 'XQCC_REVIEW')
        end
    }

    # get current XQCC_REVIEW at hand
    scope :user_current_xqcc_case, -> (user_id) {
        where(status: 'XQCC_REVIEW').where(radiographer_id: user_id)
    }

    # get all XQCC_REVIEW that was handled by this user
    scope :xqcc_pool, -> {
        where(status: 'XQCC_POOL')
    }

    # filter by status, default XQCC_REVIEW
    scope :status, -> (status) {
        status_filter = 'XQCC_REVIEW'

        unless status.blank?
            status_filter = status
        end

        where(status: status_filter)
    }

    scope :batch, -> (batch) {
        unless batch.blank?
            where(batch_id: batch)
        end
    }

    scope :result, -> (result) {
        unless result.blank?
            where(result: result)
        end
    }

    scope :analog, -> { joins(:transactionz).where(transactions: { xray_film_type: 'ANALOG' }) }

    scope :digital, -> { joins(:transactionz).where(transactions: { xray_film_type: 'DIGITAL' }) }

    scope :with_radiologist, -> { joins(:transactionz).where.not(transactions: { radiologist_id: nil }) }

    scope :without_radiologist, -> { joins(:transactionz).where(transactions: { radiologist_id: nil }) }

    scope :with_created_at_year, ->(year) { where(created_at: DateTime.new(year).beginning_of_year...DateTime.new(year).end_of_year) }
    scope :with_transmitted_at_month, ->(month) { where(transmitted_at: month.to_datetime.beginning_of_month...month.to_datetime.end_of_month) }
    scope :with_transmitted_at_year, ->(year) { where(transmitted_at: DateTime.new(year).beginning_of_year...DateTime.new(year).end_of_year) }

    scope :with_xray_code, lambda { |xray_code|
        joins(transactionz: :xray_facility)
        .where(transactionz: { xray_facilities: { code: xray_code } })
    }

    scope :today_only, -> { where("xray_reviews.transmitted_at is null or (xray_reviews.transmitted_at >= ? and xray_reviews.transmitted_at < ?)", Date.today, Date.tomorrow) }
    # end of scopes

    # authorizations
    def is_owner?(user_id)
        radiographer_id == user_id
    end

    def can_edit?
        status === 'XQCC_REVIEW' && result != 'RETAKE'
    end

    def can_request_retake?
        status === 'XQCC_REVIEW' && result === 'RETAKE'
    end
    # end of authorizations

    # accessors
    def case_review_status
        review_status = 'ASSIGN'

        if status === 'TRANSMITTED'
            review_status = "REVIEWED - #{result}"
            if self.is_iqa.eql?("Y")
                review_status = "REVIEWED - IQA"
            end
        end

        if result === 'RETAKE'
            review_status = "REVIEWED - RETAKE"
        end

        if result === 'ABORT'
            review_status = "REVIEWED - ABORT"
        end

        review_status
    end

    def is_retake?
        completed_pcr_retake = XrayRetake.where(requestable_type: XrayReview.to_s)
        .where(requestable_id: id)
        .where(status: 'COMPLETED')
        .first

        return true if completed_pcr_retake.present?

        return false
    end
    # end of accessors

    # methods
    def self.next_iqa_sequence
        ActiveRecord::Base.connection.execute("SELECT nextval('iqa_seq')")[0]["nextval"]
    end

    def self.current_iqa_sequence
        ActiveRecord::Base.connection.execute("select last_value FROM iqa_seq")[0]["last_value"]
    end

    def sync_xqcc_comments(comments)
        return if comments.blank?

        comments.each do |comment|
            unless comment.blank?
                comment_data = {
                    comment: comment
                }
                xqcc_comments.create(comment_data)
            end
        end
    end

    def sync_identicals(identical_xray_review_ids)
        ids = []
        identical_xray_review_ids.each do |identical_xray_review_id|
            ids << identical_xray_review_id.to_i
            self.xqcc_review_identicals.where(identical_xray_review_id: identical_xray_review_id.to_i).first_or_create
        end
        self.xqcc_review_identicals.where.not(identical_xray_review_id: ids).destroy_all
    end

    def non_comply
        return {} unless xray_review_details.any?

        matching_conditions = non_comply_codes.values & xray_review_details.map(&:code).map(&:to_i)
        matching_conditions.each_with_object({}) do |condition_code, hash|
            hash[non_comply_codes.invert[condition_code].to_sym] = get_condition_detail("#{condition_code}")
        end
    end

    def non_comply?
        matching_conditions = non_comply_codes.values & xray_review_details.map(&:code).map(&:to_i)
        matching_conditions.present?
    end

    def comply?
        matching_conditions = non_comply_codes.values & xray_review_details.map(&:code).map(&:to_i)
        matching_conditions.blank?
    end

    def non_comply_codes
        case xray_type
        when :digital
           Report::XqccQualitySummaryReportService::NON_COMPLY_CODES_DIGITAL
        when :analog
           Report::XqccQualitySummaryReportService::NON_COMPLY_CODES_ANALOG
        end
    end

    def review_date
        return created_at if xray_type == :digital
        return xray_test_done_date if xray_type == :analog

        nil
    end

    def xray_type
       transactionz.xray_film_type.downcase.to_sym
    end

    def get_condition_detail(code)
        if !@condition_details
            @condition_details = {}
            xray_review_details.joins("join conditions on xray_review_details.condition_id = conditions.id")
            .select("xray_review_details.*", "conditions.code as condition_code").each do |xray_review_detail|
                @condition_details[xray_review_detail.condition_code] = xray_review_detail.text_value
            end
        end
        @condition_details.key?(code) ? @condition_details[code] : nil
    end

    def reported_by
        case xray_type
        when :analog
            condition = Condition.find_by(code: 6126)   # reported_by condition
            return unless condition

            xray_review_details.find_by(condition: condition)&.text_value
        when :digital
            transactionz&.xray_reported_by
        end
    end
end
