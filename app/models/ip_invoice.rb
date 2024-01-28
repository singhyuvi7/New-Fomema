class IpInvoice < ApplicationRecord
    STATUSES = {
        "NOT_PROCESS" => "Not Process",
        "PROCESSING" => "Processing",
        "PROCESS_FAILED" => "Process Failed",
        "SUCCESS" => "Success",
        "PENDING" => "Pending",
        "FAILED" => "Failed"
    }

    belongs_to :batchable, polymorphic: true, optional: true
    
    # after_create :update_document_number  # nios insurance enhancement - to use order code as document number
    
    def update_document_number
        self.update_columns({
			document_number: generate_code
		})
    end

    def generate_code
        sprintf("I#{Time.now.strftime("%Y%m%d")}%06d", self.id)
    end
end
