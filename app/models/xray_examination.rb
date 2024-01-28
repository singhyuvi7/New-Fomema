class XrayExamination < ApplicationRecord
    DETAILS = {
        thoracic_cage: "2001",
        heart_shape_and_size: "2002",
        lung_fields: "2011",
        mediastinum_and_hila: "2003",
        pleura_hemidiaphragms_costopherenic_angles: "2004",
        focal_lesion: "2012",
        other_findings: "2013"
    }

    COMMENTS = {
        thoracic_cage_comment: "2101",
        heart_shape_and_size_comment: "2102",
        lung_fields_comment: "2111",
        mediastinum_and_hila_comment: "2103",
        pleura_hemidiaphragms_costopherenic_angles_comment: "2104",
        focal_lesion_comment: "2112",
        other_findings_comment: "2113",
        impression: "2014"
    }

    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :sourceable,     polymorphic: true, optional: true
    belongs_to :transactionz,   foreign_key: "transaction_id", class_name: "Transaction", optional: true
    # belongs_to :xray_retake,    polymorphic: true, foreign_type: "sourceable_type", foreign_key: "sourceable_id", optional: true - this is incorrectly done. need to scope it.

    has_many :xray_examination_details,     inverse_of: :xray_examination
    has_many :xray_examination_comments,    inverse_of: :xray_examination
    has_many :detail_conditions,            through: :xray_examination_details,  source: :condition, inverse_of: :xe_detail_exams
    has_many :comment_conditions,           through: :xray_examination_comments, source: :condition, inverse_of: :xe_comment_exams

    after_save :check_to_update_certification_state, if: -> { saved_changes[:transmitted_at] }

    # scopes
    scope :xray_ref_number, -> xray_ref_number { where(xray_ref_number: xray_ref_number) }
    scope :transaction_code, -> transaction_code { joins(:transactionz).where(transactions: { code: transaction_code }) }
    scope :worker_code, -> worker_code { joins(transactionz: :foreign_worker).where(foreign_workers: { code: worker_code }) }
    scope :analog, -> { joins(:transactionz).where(transactions: { xray_film_type: 'ANALOG' }) }
    scope :digital, -> { joins(:transactionz).where(transactions: { xray_film_type: 'DIGITAL' }) }
    scope :with_xray_code, lambda { |xray_code|
        joins(transactionz: :xray_facility)
            .where(transactionz: { xray_facilities: { code: xray_code } })
    }
    scope :with_created_at_year, ->(year) { where(created_at: DateTime.new(year).beginning_of_year...DateTime.new(year).end_of_year) }
    scope :done, -> { where(xray_examination_not_done: 'NO') }
    scope :viewed, -> { where(xray_viewed: true) } # for digital only
    scope :pending_viewed, -> { where(xray_viewed: false) } # for digital only
    scope :gp_certified, -> { joins(:transactionz).where.not(transactions: { doctor_transmit_date: nil }) }
    scope :pending_gp_certified, -> { joins(:transactionz).where(transactions: { doctor_transmit_date: nil }) }

    def self.xray_checks
        {
            "thoracic_cage"                                 => "Thoracic Cage",
            "heart_shape_and_size"                          => "Heart Shape & Size",
            "lung_fields"                                   => "Lung Fields",
            "mediastinum_and_hila"                          => "Mediastinum & Hila",
            "pleura_hemidiaphragms_costopherenic_angles"    => "Pleura / Hemidiaphragms / Costopherenic Angles"
        }
    end

    def self.xray_checks_yes_no_fields
        {
            "focal_lesion"                                  => "Focal Lesions",
            "other_findings"                                => "Any other findings"
        }
    end

    def result_of_exam
        return true if xray_examination_not_done == "YES"
        detail_codes = xray_examination_details.exists? # If any of the details is true, it is ABNORMAL.
    end

    # Creating methods to determine if conditions are in details or comments.
    [DETAILS, COMMENTS].map do |mapping_list|
        mapping_list.keys
    end.flatten.each do |method_name|
        define_method("#{ method_name }") do
            set_detail_comment_hash unless defined?(@detail_comment_hash)
            @detail_comment_hash[method_name]
        end
    end

    def set_detail_comment_hash
        @detail_comment_hash    = Hash.new
        @condition_code_map     = Condition.where(exam_type: "XRAY").pluck(:id, :code).to_h
        @detail_codes           = xray_examination_details.to_a.map {|detail| @condition_code_map[detail.condition_id] }
        @mapped_comments        = xray_examination_comments.to_a.map {|comment| [@condition_code_map[comment.condition_id], comment.comment] }.to_h
        set_detail_fields
        set_comment_fields
    end

    # Please do not use this to update detail or comments outside of the normal flow.
    # It will destroy records if you do not specify correctly.
    def save_examination_details_and_comments(hashes = {})
        @saved_conditions_list  = []
        save_details    hashes[:detail_fields]
        save_comments   hashes[:comment_fields], hashes[:detail_fields]
        xray_examination_details.where(transaction_id: transaction_id).where.not(condition_id: @saved_conditions_list).destroy_all
        xray_examination_comments.where(transaction_id: transaction_id).where.not(condition_id: @saved_conditions_list).destroy_all
    end

    def save_details(hash)
        return if hash.blank?
        conditions      = hash.select {|key, value| value == "true" }.keys
        key_id_map      = get_key_id_map_hash(DETAILS.invert, conditions)
        details         = xray_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            xe_detail               = details.find {|detail| detail.condition_id == condition_id }
            xe_detail               ||= xray_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            xe_detail.deleted_at    = nil
            @saved_conditions_list  << condition_id if xe_detail.save
        end
    end

    def save_comments(comments_hash, details)
        return if comments_hash.blank?
        conditions          = comments_hash.select {|key, value| value.present? }.keys
        key_id_map          = get_key_id_map_hash(COMMENTS.invert, conditions)
        included_details    = details.select {|key, value| value == "true" }.keys.map {|key| "#{ key }_comment".to_sym }

        # Remove comment if any of the xe_detail is not true.
        (COMMENTS.keys - included_details - [:impression]).each do |key|
            key_id_map.delete(key)
        end

        comments            = xray_examination_comments.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            xe_comment              = comments.find {|comment| comment.condition_id == condition_id }
            xe_comment              ||= xray_examination_comments.new(transaction_id: transaction_id, condition_id: condition_id)
            xe_comment.deleted_at   = nil
            xe_comment.comment      = comments_hash[detail_key]
            @saved_conditions_list  << condition_id if xe_comment.save
        end
    end

    def get_key_id_map_hash(code_key_map, conditions)
        condition_codes = code_key_map.select {|code, key| conditions.include?(key.to_s) }
        code_id_map     = Condition.where(code: condition_codes.keys).pluck(:code, :id)
        code_id_map.map {|code, id| [code_key_map[code], id] }.to_h.with_indifferent_access
    end

    def reset_all_details_and_comments
        reason_condition = Condition.find_by(code: "2014").try(:id)
        xray_examination_details.where(transaction_id: transaction_id).destroy_all
        xray_examination_comments.where(transaction_id: transaction_id).where.not(condition_id: reason_condition).destroy_all
    end

    def diseases
        DETAILS.each_with_object([]) do |(condition, _), array|
            array << condition.to_s.humanize if send(condition)
        end
    end

private
    def set_detail_fields
        DETAILS.each do |key, code|
            next unless @detail_codes.include?(code)
            @detail_comment_hash[key] = @detail_codes.include?(code)
        end
    end

    def set_comment_fields
        COMMENTS.each do |key, code|
            next unless @mapped_comments[code].present?
            @detail_comment_hash[key] = @mapped_comments[code]
        end
    end

    def check_to_update_certification_state
        return if sourceable_type == "XrayRetake"

        if transactionz.status == "EXAMINATION" && transactionz.laboratory_transmit_date? && transmitted_at?
            doc_exam = transactionz.doctor_examination
            doc_exam = DoctorExamination.find_or_create_by(transaction_id: transactionz.id, doctor_id: transactionz.doctor_id) if doc_exam.blank?
            doc_exam.set_initial_certification_conditions
        end
    end
end