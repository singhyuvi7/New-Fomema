class MohNotification < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,       class_name: "Transaction",  foreign_key: "transaction_id", optional: true
    belongs_to :created_by_user,    class_name: "User",         foreign_key: "created_by", optional: true

    has_one :doctor, through: :transactionz

    validates :transaction_id,   presence: true
    validates :disease,          presence: true
    validates :quarantined,      presence: true

    def self.seed_transactions(transaction_ids = [])
        transactions    = Transaction.where(id: transaction_ids).order(:id).includes(:medical_examination, :doctor_examination)
        total_size      = transactions.size

        transactions.each.with_index(1) do |transaction, index|
            puts "Transaction ID: #{ transaction.id } (#{ index } / #{ total_size })"
            examination     = transaction.medical_examination || transaction.doctor_examination
            quarantine      = transaction.medical_quarantine_release_date? || transaction.xray_quarantine_release_date? ? "Y" : "N"
            # Get the latest date for quarantine release. Will be null if there arent either ones.
            release_date    = [transaction.medical_quarantine_release_date, transaction.xray_quarantine_release_date].compact.max

            diseases = MohNotification.communicable_diseases_hash.map do |key, value|
                value if examination.try(key)
            end.compact

            diseases.each do |disease|
                MohNotification.find_or_create_by(transaction_id: transaction.id, disease: disease, quarantined: quarantine, quarantine_release_date: release_date)
            end
        end
    end

    def self.communicable_diseases_hash
        {
            condition_hiv: "HIV",
            condition_tuberculosis: "TB",
            condition_malaria: "MALARIA",
            condition_leprosy: "LEPROSY",
            condition_std: "SYPHILIS",
            condition_hepatitis: "HEPB"
        }
    end
end