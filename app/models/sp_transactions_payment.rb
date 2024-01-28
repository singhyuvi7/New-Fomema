class SpTransactionsPayment < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :service_providable, polymorphic: true
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :service_provider_group, optional: true
    
    # scope
    scope :is_group, -> {
        where(batchable_type: ServiceProviderGroup.to_s)
    }

    scope :is_individual, -> {
        where.not(batchable_type: ServiceProviderGroup.to_s)
    }

    def self.to_csv(transactions)
        attributes = ["#","Trans ID","Worker Code","Worker Name","Gender","Doctor Code","Doctor Name","Clinic Name","Xray Code","Xray Name","Lab Code","Lab Name","Employer Code","Employer Name","Examination Date","Xray Submit Date","Lab Submit Date","Certify Date","Physical Test Done","IMM IND.","Payment Status"]

        CSV.generate(headers: true) do |csv| 
            csv << attributes
            transactions.each_with_index do |transaction, index|

                doctor_payment   = transaction.sp_transactions_payments.where(:service_providable_type => Doctor.to_s).first
                xray_payment     = transaction.sp_transactions_payments.where(:service_providable_type => XrayFacility.to_s).first
                lab_payment      = transaction.sp_transactions_payments.where(:service_providable_type => Laboratory.to_s).first

                transaction_id = transaction.code
                worker_code = transaction.foreign_worker.code
                worker_name = transaction.foreign_worker.name
                gender = ForeignWorker::GENDERS[transaction.fw_gender]

                doctor_code = transaction.doctor.code
                doctor_name = transaction.doctor.name
                clinic_name = transaction.doctor.clinic_name

                xray_code = transaction.xray_facility.code
                xray_name = transaction.xray_facility.name

                lab_code = transaction.laboratory.code
                lab_name = transaction.laboratory.name

                employer_code = transaction.employer.code
                employer_name = transaction.employer.name

                medical_examination_date = transaction.medical_examination_date.present? ? transaction.medical_examination_date.strftime("%d/%m/%Y") : '-'

                xray_transmit_date = transaction.xray_transmit_date.present? ? transaction.xray_transmit_date.strftime("%d/%m/%Y") : '-'

                lab_transmit_date = transaction.laboratory_transmit_date.present? ? transaction.laboratory_transmit_date.strftime("%d/%m/%Y") : '-'

                certification_date = transaction.certification_date.present? ? transaction.certification_date.strftime("%d/%m/%Y") : '-'

                physical_exam_done = transaction.physical_exam_not_done == false ? 'Yes' : 'No'

                ignore_expiry = transaction.ignore_expiry ? 'Yes' : 'No'

                payment_made = []
                if transaction.certification_date.present? and transaction.physical_exam_not_done != true
                    # certified and physical exam done
                    payment_made << 'Auto'
                else
                    if doctor_payment.present?
                        payment_made << 'D'
                    end

                    if xray_payment.present?
                        payment_made << 'X'
                    end

                    if lab_payment.present?
                        payment_made << 'L'
                    end
                end
                payment_made = payment_made.join(', ')

                row = [index+1,transaction_id,worker_code,worker_name,gender,doctor_code,doctor_name,clinic_name,xray_code,xray_name,lab_code,lab_name,employer_code,employer_name,medical_examination_date,xray_transmit_date,lab_transmit_date,certification_date,physical_exam_done,ignore_expiry,payment_made]
                csv << row
            end
        end
    end
end
