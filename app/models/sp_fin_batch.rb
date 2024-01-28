class SpFinBatch < ApplicationRecord
    STATUSES = {
        "NOT_PROCESS" => "Not Process",
        "PROCESSING" => "Processing",
        "PROCESS_FAILED" => "Process Failed",
        "SUCCESS" => "Success",
        "PENDING" => "Pending",
        "FAILED" => "Failed"
    }

    audited
    include CaptureAuthor

    belongs_to :batchable, polymorphic: true
    belongs_to :fin_batch, optional: true
    has_many :sp_fin_batch_items
    belongs_to :bank, optional: true

    after_save :check_status, if: -> { saved_changes[:status] }

    # scope
    scope :is_group, -> {
        where(batchable_type: ServiceProviderGroup.to_s)
    }

    scope :is_individual, -> {
        where.not(batchable_type: ServiceProviderGroup.to_s)
    }

    scope :search_group_service_provider, -> (service_provider){
        joins("LEFT JOIN service_provider_groups ON service_provider_groups.id = sp_fin_batches.batchable_id").where(:service_provider_type => service_provider)
    }

    scope :search_individual_service_provider, -> (service_provider){
        where(:batchable_type => service_provider)
    }

    scope :search_status, -> (status){
        return all if status.blank?
        where(:status => status)
    }

    scope :search_service_provider, -> (service_provider){
        return all if service_provider.blank?
        where(:service_provider_type => service_provider)
    }

    def check_status
        statuses = SpFinBatch.where(:fin_batch_id => fin_batch_id).distinct.pluck(:status)
        if statuses.include? 'NOT_PROCESS'
            FinBatch.find(fin_batch_id).update(status: 'NOT_PROCESS')
        elsif statuses.include? 'PROCESS_FAILED'
            FinBatch.find(fin_batch_id).update(status: 'PROCESS_FAILED')
        elsif statuses.include? 'PROCESSING'
            FinBatch.find(fin_batch_id).update(status: 'PROCESSING')
        elsif statuses.include? 'FAILED'
            FinBatch.find(fin_batch_id).update(status: 'FAILED')
        elsif statuses.include? 'PENDING'
            FinBatch.find(fin_batch_id).update(status: 'PENDING')
        else
            FinBatch.find(fin_batch_id).update(status: 'SUCCESS')
        end
    end
end
