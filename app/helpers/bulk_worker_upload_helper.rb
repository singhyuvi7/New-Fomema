module BulkWorkerUploadHelper

    def validate_worker(employer, worker, site)
        worker_validator = ForeignWorkerValidator.new(employer, worker, site)
        result = worker_validator.validate
    end

end