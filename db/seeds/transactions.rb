employer = Employer.find_by(business_registration_number: "EMP999BRN")
doctor = Doctor.find_by(code: "D9ED999999")

employer.foreign_workers.each_with_index do |foreign_worker, idx|
    foreign_worker.update_code
    transaction_no = 999999 - idx
    fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")

    order = Order.create({
        customerable: foreign_worker.employer,
        category: "TRANSACTION_REGISTRATION",
        payment_method: PaymentMethod.find_by(code: "IPAY88"),
        status: "PAID"
    })

    order_item = order.order_items.create({
        order_itemable: foreign_worker,
        fee_id: fee.id,
        amount: fee.amount,
    })

    transaction = Transaction.create({
        order_item_id: order_item.id,
        foreign_worker_id: foreign_worker.id,
        employer_id: foreign_worker.employer.id,
        transaction_date: "2020-01-01",
        expired_at: "2020-01-01".to_date + 1.year,
        approval_status: 'NEW_APPROVED',
        doctor_id: doctor.id,
        xray_facility_id: doctor.xray_facility.id,
        laboratory_id: doctor.laboratory.id,
        status: "EXAMINATION",
        worker_matched: true,
        worker_consented: true,
        worker_identity_confirmed: true,
        medical_examination_date: "2020-01-01 09:00:00",
        doctor_fp_result: 2,
        xray_worker_identity_confirmed: true,
        xray_film_type: "DIGITAL",
        xray_reporter_type: "SELF",
        xray_fp_result: 2,
        fw_code: foreign_worker.code,
        fw_name: foreign_worker.name,
        fw_gender: foreign_worker.gender,
        fw_date_of_birth: foreign_worker.date_of_birth,
        fw_passport_number: foreign_worker.passport_number,
        fw_country_id: foreign_worker.country_id,
        fw_maid_online: foreign_worker.maid_online,
        fw_pati: foreign_worker.pati,
        fw_plks_number: foreign_worker.plks_number
    })
    transaction.update({
        code: sprintf("20200101%06d", transaction_no)
    })
    XrayExamination.create({
        transaction_id: transaction.id,
        sourceable_id: transaction.id,
        sourceable_type: "Transaction",
        result: "NORMAL",
        xray_taken_date: "2020-01-01"
    })
end

puts("transactions seeded")