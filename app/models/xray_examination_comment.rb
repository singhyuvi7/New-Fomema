class XrayExaminationComment < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,         class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :xray_examination_comments, optional: true
    belongs_to :condition,            inverse_of: :xray_examination_comments, optional: true
    belongs_to :xray_examination,     inverse_of: :xray_examination_comments, optional: true

    validates :transaction_id,        presence: true
    validates :condition_id,          presence: true
    validates :xray_examination_id,   presence: true
end