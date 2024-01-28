class FinBatch < ApplicationRecord
    SERVICE_PROVIDER_TYPES = {
        "Doctor" => "Doctor",
        "Laboratory" => "Laboratory",
        "XrayFacility" => "X-Ray Facility"
    }

    STATUSES = {
        "NOT_PROCESS" => "Not Process",
        "PROCESSING" => "Processing",
        "PROCESS_FAILED" => "Process Failed",
        "PENDING" => "Pending",
        "SUCCESS" => "Success",
        "FAILED" => "Failed Payment Found"
    }

    audited
    include CaptureAuthor

    has_many :sp_fin_batches

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('fin_batches.code = ?', "#{code}")
    end

    def self.search_status(status)
        return all if status.blank?
        where('sp_fin_batches.status = ?',status)
    end

    def self.search_date_range(start_date,end_date)
        return all if (start_date.blank? && end_date.blank?)

        if start_date.blank? || end_date.blank? 
            return where.not('DATE(fin_batches.end_date) < ?',start_date) if start_date.present?
            return where.not('DATE(fin_batches.start_date) > ?',end_date) if end_date.present?
        else 
            where.not('DATE(fin_batches.end_date) < ? or DATE(fin_batches.start_date) > ?', start_date, end_date)
        end
    end

    def self.search_service_provider(service_provider)
        return all if service_provider.blank?
        where('sp_fin_batches.service_provider_type = ?',service_provider)
    end

    def self.to_csv(service_provider)
        attributes = ["Batch Code","Provider State","SP Code","Group Code","SP Name","Group Name","Clinic Name","Service Type","Payment By","Status","Worker Count","Billable Amount","Total Amount"]
    
        CSV.generate(headers: true) do |csv| 
            csv << attributes
            grand_total = 0

            all.each do |sp_batch|
                sp_batches = sp_batch.sp_fin_batches.order("batchable_type = 'ServiceProviderGroup' ASC")

                group_batches = service_provider.present? ? sp_batch.sp_fin_batches.is_group.search_group_service_provider(service_provider) : sp_batch.sp_fin_batches.is_group
                individual_batches = service_provider.present? ? sp_batch.sp_fin_batches.search_individual_service_provider(service_provider) : sp_batch.sp_fin_batches.is_individual

                sp_batches = individual_batches+group_batches

                sp_batches.each do |sp_batch|
                    if sp_batch.batchable_type === ServiceProviderGroup.to_s
                        payment_by = 'Group'
                        service_provider = sp_batch.batchable&.category
                        sp_code = '-'
                        sp_name = '-'
                        group_code = sp_batch.batchable.try(:code)
                        group_name = sp_batch.batchable.try(:name)

                        provider_state = sp_batch.batchable.try(:state).try(:name)
                        worker_count = ''
                        clinic_name = '-'
                        billable_amount = ''
                    else
                        sp_details = sp_batch.batchable

                        payment_by = 'Individual'
                        service_provider = sp_batch&.batchable_type
                        sp_code = sp_details.code
                        sp_name = sp_batch.company_name.present? ? sp_batch.company_name : sp_details.name
                        group_code = '-'
                        group_name = '-'
                        clinic_name = sp_details[:clinic_name].present? ? sp_details.clinic_name : '-'
                        provider_state = sp_details.try(:state).try(:name)

                        worker_count = sp_batch.sp_fin_batch_items.count
                        billable_amount = sp_batch.total_amount
                    end

                    batch_code = sp_batch.fin_batch.code
                    status = SpFinBatch::STATUSES[sp_batch.status]
                    amount = sp_batch.total_amount
                    gst = 0
                    grand_total += amount
                    
                    row = [batch_code,provider_state,sp_code,group_code,sp_name,group_name,clinic_name,service_provider,payment_by,status,worker_count,billable_amount,amount]
                    csv << row

                    if payment_by === 'Group'
                        # get from sp_fin_batch_items
                        items = sp_batch.sp_fin_batch_items
                        existed_provider = []
                        items.each do |item|
                            sp_details = item.transactionz.send(service_provider.constantize.model_name.param_key)

                            if existed_provider.include? sp_details.code
                            else
                                existed_provider.push(sp_details.code)

                                sp_details = item.itemable
                                sp_code = sp_details.code
                                sp_name = item.company_name.present? ? item.company_name : sp_details.name
                                billable_amount = sp_batch.sp_fin_batch_items.where(:itemable_id => sp_details.id).where(:itemable_type => service_provider).sum(:amount)

                                clinic_name = sp_details[:clinic_name].present? ? sp_details.clinic_name : '-'
                                provider_state = sp_details.state.name
                                worker_count = sp_batch.sp_fin_batch_items.where(:itemable_id => sp_details.id).where(:itemable_type => service_provider).count
                                
                                row = [batch_code,provider_state,sp_code,group_code,sp_name,group_name,clinic_name,service_provider,payment_by,status,worker_count,billable_amount,'']
                                csv << row
                            end
                        end
                    end
                end
            end
            csv << ['','','','','','','','','','','','Grand Total',grand_total]
        end
    end
end