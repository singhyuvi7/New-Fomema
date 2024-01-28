class BiodataTransaction < ApplicationRecord
    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", optional: true
    belongs_to :order_item, optional: true

    scope :have_id, -> {
        where(status: 'SUCCESS').where.not(afis_id: nil)
    }

    scope :no_id, -> {
        where(status: 'SUCCESS').where(afis_id: nil)
    }

    scope :no_biodata, -> {
        where("status != 'SUCCESS' or status is null")
    }
end
