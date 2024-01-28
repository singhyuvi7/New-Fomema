class CreateTransactions < ActiveRecord::Migration[5.2]
    def change
        # create_table :transactions do |t|
        create_range_partition :transactions, partition_key: ->{ "transaction_date" } do |t|
            t.string :code, index: true
            t.belongs_to :order_item
            t.belongs_to :foreign_worker
            t.belongs_to :employer
            t.belongs_to :doctor
            t.belongs_to :laboratory
            t.belongs_to :xray_facility
            t.belongs_to :radiologist
            t.belongs_to :change_doctor_reason
            t.text :change_doctor_reason_comment
            t.datetime :transaction_date, index: true
            t.datetime :medical_examination_date, index: true
            t.datetime :doctor_transmit_date
            t.datetime :laboratory_transmit_date
            t.datetime :xray_transmit_date
            t.datetime :expired_at
            t.datetime :extended_at
            t.datetime :certification_date
            t.string :status, index: true, default: 'NEW'
            t.text :comment

            t.boolean :worker_matched, default: false
            t.boolean :worker_consented, default: false
            t.boolean :worker_identity_confirmed, default: false

            t.boolean :xray_worker_identity_confirmed, default: false
            t.string :xray_film_type # analogue or digital
            t.string :xray_reporter_type # self reporting or assign to radiologist

            # Medical Status (after Doctor Examinations)
            t.boolean :medical_tcupi, index: true, default: false
            t.string :medical_status
            t.string :medical_result

            # xray review
            t.string :xray_status
            t.string :xray_result
            t.string :xray_retake_status
            t.text :xray_retake_comment
            t.bigint :retake_xray_facility_id, index: true

            t.bigint :xray_pending_review_id, index: true
            t.string :xray_pending_review_type
            t.string :xray_pending_review_decision
            t.text :xray_pending_review_comment
            t.bigint :xray_pending_review_approval_id, index: true
            t.string :xray_pending_review_approval_decision
            t.text :xray_pending_review_approval_comment

            t.bigint :xray_xqcc_review_id, index: true
            t.string :xray_xqcc_review_decision
            t.text :xray_xqcc_review_comment

            t.bigint :xray_pcr_review_id, index: true
            t.string :xray_pcr_review_decision
            t.text :xray_pcr_review_comment

            t.bigint :xray_pending_decision_id, index: true
            t.string :xray_pending_decision_decision
            t.text :xray_pending_decision_comment
            t.bigint :xray_pending_decision_approval_id, index: true
            t.string :xray_pending_decision_approval_decision
            t.text :xray_pending_decision_approval_comment
            # /xray review

            t.string :final_result, index:true

            # cancellation
            t.text :cancel_reason
            t.bigint :cancelled_by, index: true
            t.datetime :cancelled_at

            # approval related field
            t.string :approval_status, index: true
            t.string :approval_remark

            # fingerprint results
            t.integer :doctor_fp_result
            t.integer :xray_fp_result

            # allow transaction to bypass fingerprint verification
            t.boolean :doctor_fp
            t.boolean :xray_fp

            # change doctor field
            t.bigint :doctor_changed_by, index: true
            t.datetime :doctor_changed_at

            t.timestamps
            t.bigint :created_by, index: true
            t.bigint :updated_by, index: true
        end

        execute("create table transactions_default partition of transactions (
            constraint transactions_default_pkey primary key (id)
        ) default")

        # min - march 1998
        (1998..Time.now.year).each do |year|
            [1,7].each do |month|
                month_date = Date.new(year, month, 1)
                create_range_partition_of :transactions, name: sprintf("transactions_y%04dm%02d", year, month), start_range: month_date.to_formatted_s("%F"), end_range: (month_date + 6.month).to_formatted_s("%F")
            end
        end
    end
end
