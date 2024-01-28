class FingerprintRequest < ApplicationRecord
    after_create :update_transaction_number

    belongs_to :foreign_worker

    has_one :fingerprint_response

    def update_transaction_number
        transaction_number = sprintf("#{ENV["JIM_FP_TRANSACTION_NUMBER_PREFIX"]}#{Time.now.strftime("%Y%m%d")}%06d", self.id)
        self.update({
			app_transaction_id: transaction_number
		})
    end
end
