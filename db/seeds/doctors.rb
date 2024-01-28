# Doctors
fee = Fee.find_by(code: "DOCTOR_REGISTRATION")

town = Town.find_by(code: "E021")
@district_health_offices = DistrictHealthOffice.all if !@district_health_offices
@ipay88 = PaymentMethod.find_by(code: "IPAY88") if !@ipay88

[
    {no: 999, code: "D9ED999999"},
    {no: 998, code: "D1ED999998"},
    {no: 997, code: "D2ED999997"},
    {no: 996, code: "D3ED999996"},
    {no: 995, code: "D4ED999995"},
].each do |row|
    no = row[:no];
    doctor = Doctor.create!({
        code: row[:code],
        name: sprintf("DOCTOR %03d", no),
        clinic_name: sprintf("DOCTOR %03d CLINIC", no),
        icno: sprintf("80010101%04d", no),
        title_id: Title.order("random()").first.id,
        address1: "LINE 1",
        address2: "LINE 2",
        address3: "",
        address4: "",
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        mobile: sprintf("01000002%02d", no),
        email: sprintf("fonghy+doc%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+doc%03dp@bookdoc.com", no),
        qualification: sprintf("DOC%03dQUALIFICATION", no),
        apc_year: 2019,
        apc_number: sprintf("DOC%03d APC NUMBER", no),
        renewal_agreement_date: DateTime.now,
        district_health_office_id: @district_health_offices.sample.id,
        has_xray: false,
        fp_device: 1,
        quota: 500,
        quota_used: 0,
        solo_clinic: 2,
        group_clinic: 4,
        xray_facility_id: XrayFacility.find_by(name: sprintf("XRAY FACILITY %03d", no)).id,
        laboratory_id: Laboratory.find_by(name: sprintf("LABORATORY %03d", no)).id,
        status: "ACTIVE",
        comment: "",
        pairing_options: {"xray_facilities" => ["1", "2"], "laboratories" => ["1", "2"]},
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: "",
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    })

    doctor.create_user(skip_confirmation: true, update_password: false)
    doctor.user.update(password: "12345678")

    order = Order.create!({
        customerable: doctor,
        category: "DOCTOR_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: doctor,
        fee_id: fee.id,
        amount: fee.amount
    })
end

=begin
r = 999..995
(r.first).downto(r.last).each do |no|
    doctor = Doctor.create!({
        name: sprintf("DOCTOR %03d", no),
        clinic_name: sprintf("DOCTOR %03d CLINIC", no),
        icno: sprintf("80010101%04d", no),
        title_id: Title.order("random()").first.id,
        address1: "LINE 1",
        address2: "LINE 2",
        address3: "",
        address4: "",
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        mobile: sprintf("01000002%02d", no),
        email: sprintf("fonghy+doc%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+doc%03dp@bookdoc.com", no),
        qualification: sprintf("DOC%03dQUALIFICATION", no),
        apc_year: 2019,
        apc_number: sprintf("DOC%03d APC NUMBER", no),
        renewal_agreement_date: DateTime.now,
        district_health_office_id: @district_health_offices.sample.id,
        has_xray: false,
        fp_device: 1,
        quota: 500,
        quota_used: 0,
        solo_clinic: 2,
        group_clinic: 4,
        xray_facility_id: XrayFacility.find_by(name: sprintf("XRAY FACILITY %03d", no)).id,
        laboratory_id: Laboratory.find_by(name: sprintf("LABORATORY %03d", no)).id,
        status: "ACTIVE",
        comment: "",
        pairing_options: {"xray_facilities" => ["1", "2"], "laboratories" => ["1", "2"]},
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: "",
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    })
    doctor.update_code
    doctor.update_attributes(code: "#{doctor.code[0...4]}999#{no}")
    doctor.create_user(skip_confirmation: true, update_password: false)
    order = Order.create!({
        customerable: doctor,
        category: "DOCTOR_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: doctor,
        fee_id: fee.id,
        amount: fee.amount
    })
end

d = Doctor.find(1)
d.update({
    code: 'D9ED999999'
})
d.user.update({
    username: "D9ED999999"
})
d = Doctor.find(2)
d.update({
    code: 'D1ED999998'
})
d.user.update({
    username: "D1ED999998"
})
d = Doctor.find(3)
d.update({
    code: 'D2ED999997'
})
d.user.update({
    username: "D2ED999997"
})
d = Doctor.find(4)
d.update({
    code: 'D3ED999996'
})
d.user.update({
    username: "D3ED999996"
})
d = Doctor.find(5)
d.update({
    code: 'D4ED999995'
})
d.user.update({
    username: "D4ED999995"
})

(1..(@sample_count || 10)).each do |no|
    town = @towns.sample

    doctor = Doctor.create!(
        code: nil,
        name: sprintf("DOC %03d", no),
        clinic_name: sprintf("DOC %03d CLINIC", no),
        icno: sprintf("81010101%04d", no),
        title_id: Title.order("random()").first.id,
        address1: "LINE 1",
        address2: "LINE 2",
        address3: "",
        address4: "",
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        mobile: sprintf("01000002%02d", no),
        email: sprintf("fonghy+doc%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+doc%03dp@bookdoc.com", no),
        qualification: sprintf("DOC%03dQUALIFICATION", no),
        apc_year: 2019,
        apc_number: sprintf("DOC%03d APC NUMBER", no),
        renewal_agreement_date: DateTime.now,
        district_health_office_id: @district_health_offices.sample.id,
        has_xray: false,
        fp_device: 1,
        quota: 500,
        quota_used: 0,
        solo_clinic: 2,
        group_clinic: 4,
        xray_facility_id: XrayFacility.find_by(name: sprintf("XRAY %03d", no)).id,
        laboratory_id: Laboratory.find_by(name: sprintf("LAB %03d", no)).id,
        status: "ACTIVE",
        comment: "",
        pairing_options: {"xray_facilities" => ["1", "2"], "laboratories" => ["1", "2"]},
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: "",
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    )
    doctor.update_code
    doctor.create_user(skip_confirmation: true, update_password: false)
    order = Order.create!({
        customerable: doctor,
        category: "DOCTOR_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: doctor,
        fee_id: fee.id,
        amount: fee.amount
    })
end
=end

puts "doctors seeded"