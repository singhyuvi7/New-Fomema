class TransactionStatic < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,   class_name: "Transaction",  foreign_key: "transaction_id", optional: true
    belongs_to :country, optional: true
    belongs_to :employer_town,  class_name: "Town",         foreign_key: "emp_town_id", optional: true
    belongs_to :employer_state, class_name: "State",        foreign_key: "emp_state_id", optional: true
    belongs_to :doctor_town,    class_name: "Town",         foreign_key: "doc_town_id", optional: true
    belongs_to :doctor_state,   class_name: "State",        foreign_key: "doc_state_id", optional: true

    def self.seed_transaction_static(start_date, end_date)
        transactions    = Transaction.where.not(final_result: nil).where(final_result_date: start_date...end_date).order(:id).includes(:medical_examination, :doctor_examination, :xray_facility, :laboratory, :doctor, :employer, foreign_worker: [:job_type])
        total_size      = transactions.size

        transactions.each.with_index(1) do |transaction, index|
            puts "Transaction ID: #{ transaction.id } (#{ index } / #{ total_size })"
            exam                = transaction.medical_examination || transaction.doctor_examination
            foreign_worker      = transaction.foreign_worker
            employer            = transaction.employer
            doctor              = transaction.doctor
            xray_facility       = transaction.xray_facility
            laboratory          = transaction.laboratory
            transaction_static  = TransactionStatic.find_or_initialize_by(transaction_id: transaction.id)
            next if transaction_static.id? # Do not need to update, they should not change at all.

            parameters          = {
                code: transaction.code,
                worker_code: foreign_worker&.code,
                worker_name: foreign_worker&.name,
                passport_number: foreign_worker&.passport_number,
                country_id: foreign_worker&.country_id,
                emp_code: employer&.code,
                emp_name: employer&.name,
                emp_address1: employer&.address1,
                emp_address2: employer&.address2,
                emp_address3: employer&.address3,
                emp_address4: employer&.address4,
                emp_postcode: employer&.postcode,
                emp_town_id: employer&.town_id,
                emp_state_id: employer&.state_id,
                doc_code: doctor&.code,
                doc_name: doctor&.name,
                clinic_name: doctor&.clinic_name,
                doc_phone: doctor&.phone,
                doc_address1: doctor&.address1,
                doc_address2: doctor&.address2,
                doc_address3: doctor&.address3,
                doc_address4: doctor&.address4,
                doc_postcode: doctor&.postcode,
                doc_town_id: doctor&.town_id,
                doc_state_id: doctor&.state_id,
                xray_code: transaction.xray_facility&.code,
                xray_name: transaction.xray_facility&.name,
                lab_code: transaction.laboratory&.code,
                lab_name: transaction.laboratory&.name,
                job_type: foreign_worker&.job_type&.name,
                gender: foreign_worker&.gender,
                dob: foreign_worker&.date_of_birth.to_s,
                final_result: transaction.final_result,
                tcupi_ind: transaction.tcupi_date? ? "Y" : "N",
                arrival_date: foreign_worker&.arrival_date,
                transaction_date: transaction.transaction_date,
                examination_date: transaction.medical_examination_date,
                certify_date: transaction.certification_date
            }

            if transaction.physical_exam_not_done
                parameters.merge! TransactionStatic.condition_hash_map.map {|key, field| [key, 0] }.to_h
            else
                parameters.merge! TransactionStatic.condition_hash_map.map {|key, field| [key, exam.try(field) ? 1 : 0] }.to_h
            end

            transaction_static.update(parameters)
        end
    end

    def self.condition_hash_map
        {
            hiv:                    :condition_hiv,
            tuberculosis:           :condition_tuberculosis,
            malaria:                :condition_malaria,
            leprosy:                :condition_leprosy,
            std:                    :condition_std,
            hepatitis:              :condition_hepatitis,
            cancer:                 :condition_cancer,
            epilepsy:               :condition_epilepsy,
            psychiatric_disorder:   :condition_psychiatric_disorder,
            other:                  :condition_other,
            hypertension:           :condition_hypertension,
            heart_diseases:         :condition_heart_diseases,
            bronchial_asthma:       :condition_bronchial_asthma,
            diabetes_mellitus:      :condition_diabetes_mellitus,
            peptic_ulcer:           :condition_peptic_ulcer,
            kidney_diseases:        :condition_kidney_diseases,
            pregnant:               :condition_urine_for_pregnant,
            opiates:                :condition_urine_for_opiates,
            cannabis:               :condition_urine_for_cannabis
        }
    end
end