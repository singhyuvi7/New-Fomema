class MedicalExamination < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor
    include DoctorAndMedicalExaminationConstants

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"

    has_many :medical_examination_details,  inverse_of: :medical_examination
    has_many :medical_examination_comments, inverse_of: :medical_examination
    has_many :detail_conditions,            through: :medical_examination_details,  source: :condition, inverse_of: :me_detail_exams
    has_many :comment_conditions,           through: :medical_examination_comments, source: :condition, inverse_of: :me_comment_exams

    has_one  :medical_original_condition, inverse_of: :medical_examination

    def result_of_exam
        return true if suitability == "UNSUITABLE"
        codes = [HISTORY, PHYSICAL, SYSTEM_1, SYSTEM_2].map {|hash| hash.values }.flatten
        (detail_conditions.pluck(:code) & codes).present?
    end

    # Please do not use this to update detail or comments outside of the normal flow.
    # It will destroy records if you do not specify correctly.
    def save_examination_details_and_comments(hashes = {})
        saved_conditions_list = save_details_for_regular_fields(hashes[:regular_fields]) + save_comments(hashes[:comments])
        exempted              = Condition.where.not(code: DoctorExamination::CERTIFICATION.values + ["5501"]).pluck(:id)
        medical_examination_details.where(transaction_id: transaction_id).where.not(condition_id: saved_conditions_list + exempted).destroy_all
        medical_examination_comments.where(transaction_id: transaction_id).where.not(condition_id: saved_conditions_list + exempted).destroy_all
    end

    def auto_save_examination_details_and_comments(hashes = {})
        saved_conditions_list = save_details_for_regular_fields(hashes[:regular_fields]) + save_comments(hashes[:comments])
    end
private
    def save_details_for_regular_fields(hash)
        return [] if hash.blank?
        conditions        = hash.select { |key, value| value == "true" }.keys
        code_key_map      = [CERTIFICATION].inject(&:merge).invert
        key_id_map        = get_key_id_map_hash(code_key_map, conditions)
        details           = medical_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a
        saved_details_ids = []

        key_id_map.each do |detail_key, condition_id|
            me_detail             = details.find { |detail| detail.condition_id == condition_id }
            me_detail             ||= medical_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            me_detail.deleted_at  = nil
            saved_details_ids     << condition_id if me_detail.save
        end

        saved_details_ids
    end

    def save_comments(hash)
        return [] if hash.blank?
        conditions          = hash.select { |key, value| value.present? }.keys
        key_id_map          = get_key_id_map_hash({ "5501" => :certification_comment }, conditions)
        comments            = medical_examination_comments.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a
        saved_comments_ids  = []

        key_id_map.each do |detail_key, condition_id|
            me_comment              = comments.find { |comment| comment.condition_id == condition_id }
            me_comment              ||= medical_examination_comments.new(transaction_id: transaction_id, condition_id: condition_id)
            me_comment.deleted_at   = nil
            me_comment.comment      = hash[detail_key]
            saved_comments_ids      << condition_id if me_comment.save
        end

        saved_comments_ids
    end

    def get_key_id_map_hash(code_key_map, conditions)
        condition_codes = code_key_map.select { |code, key| conditions.include?(key.to_s) }
        code_id_map     = Condition.where(code: condition_codes.keys).pluck(:code, :id)
        code_id_map.map { |code, id| [code_key_map[code], id] }.to_h.with_indifferent_access
    end
end