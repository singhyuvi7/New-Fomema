class SpFinBatchItem < ApplicationRecord
    audited

    belongs_to :sp_fin_batch
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :itemable, polymorphic: true, optional: true

    after_create :update_document_number

    def update_document_number
        self.update_columns({
			document_number: generate_code
		})
    end

    def generate_code
        sprintf("#{Time.now.strftime("%Y%m%d")}%06d", self.id)
    end

    def self.to_csv(transactions,service_provider)

        attributes = ["#","Code", "Name", "Clinic Name", "Address", "Worker Code", "Worker Name", "Certified Date", "Payment Date", "Gender","Amount","Payment Type","Group Code"]
        total_amount = 0

        CSV.generate(headers: true) do |csv| 
            csv << attributes

            transactions.each_with_index do |transaction, index|
                worker = transaction.foreign_worker
                service_provider_details = transaction.send(service_provider.constantize.model_name.param_key)

                if transaction.sp_fin_batch_item.empty?
                    # manual payment
                    item = transaction.sp_transactions_payments.where(:service_providable_type => service_provider).first
                    next if item.nil?
                    group_code =  item.service_provider_group_id.present? ? item.service_provider_group.code : 'NON-GROUP'
                    payment_type = 'MANUAL'
                    payment_date = item.pay_at.strftime("%d/%m/%Y")
                else
                    item = transaction.sp_fin_batch_item.where(:itemable_type => service_provider).first
                    if item.nil? or item.sp_fin_batch.nil?
                        next
                    end
                    group_code = item.sp_fin_batch.batchable_type == ServiceProviderGroup.to_s ? item.sp_fin_batch.batchable.code : 'NON-GROUP'
                    payment_type = 'AUTO'
                    payment_date = item.created_at.strftime("%d/%m/%Y")
                end

                if service_provider == Doctor.to_s
                    name = service_provider_details.company_name.present? ? service_provider_details.company_name : service_provider_details.name
                    clinic_name = service_provider_details.clinic_name
                else
                    name = service_provider_details.name
                    clinic_name = '-'
                end

                code = service_provider_details.code
                address = [service_provider_details.address1,service_provider_details.address2,service_provider_details.address3,service_provider_details.address4,service_provider_details.town.name,service_provider_details.postcode,service_provider_details.state.name].reject(&:blank?).compact.join(",")
                worker_code = transaction&.fw_code
                worker_name = transaction&.fw_name
                certified_date = transaction.certification_date.present? ? transaction.certification_date.strftime("%d/%m/%Y") : '-'
                gender = ForeignWorker::GENDERS[transaction&.fw_gender]
                amount = item.amount
                group = group_code

                total_amount += amount

                row = [index+1,code,name,clinic_name,address,worker_code,worker_name,certified_date,payment_date,gender,amount,payment_type,group]
                csv << row
            end
            csv << ['','','','','','','','','','Total:',total_amount,'','']
        end
    end
end
