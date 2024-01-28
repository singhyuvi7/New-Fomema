# xray facilities
fee = Fee.find_by(code: "XRAY_FACILITY_REGISTRATION")

town = Town.find_by(code: "E021")
@district_health_offices = DistrictHealthOffice.all if !@district_health_offices
@ipay88 = PaymentMethod.find_by(code: "IPAY88") if !@ipay88

[
    {no: 999, code: "X4EX999999"},
    {no: 998, code: "X5EX999998"},
    {no: 997, code: "X6EX999997"},
    {no: 996, code: "X7EX999996"},
    {no: 995, code: "X8EX999995"},
].each do |row|
    no = row[:no];
    xray_facility = XrayFacility.create!({
        code: row[:code],
        name: sprintf("XRAY FACILITY %03d", no),
        address1: "LINE 1",
        address2: "LINE 2",
        address3: "",
        address4: "",
        country_id: Country.find_by(code: Country::MALAYSIA_CODE).id,
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        email: sprintf("fonghy+xray%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+xray%03dp@bookdoc.com", no),
        title_id: Title.order("random()").first.id,
        icno: sprintf("ICNO%08d", no),
        mobile: sprintf("01%08d", no),
        qualification: sprintf("XRAY%03dQUALIFICATION", no),
        status: "ACTIVE",
        film_type: "DIGITAL",
        district_health_office_id: @district_health_offices.sample.id,
        xray_license_number: sprintf("XRAY%03d LICENSE NUMBER", no),
        xray_file_number: sprintf("XRAY%03d FILE NUMBER", no),
        xray_fac_flag: false,
        xray_license_tujuan: sprintf("XRAY%03d LICENSE TUJUAN", no),
        xray_license_expiry_date: DateTime.now,
        radiologist_operated: true,
        radiologist_name: sprintf("XRAY%03d RADIOLOGIST NAME", no),
        apc_year: 2019,
        apc_number: sprintf("XRAY%03d APC NUMBER", no),
        renewal_agreement_date: "2019-01-01",
        fp_device: 1,
        comment: "",
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: nil,
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    })

    xray_facility.create_user(skip_confirmation: true, update_password: false)
    xray_facility.user.update(password: "12345678")

    order = Order.create!({
        customerable: xray_facility,
        category: "XRAY_FACILITY_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: xray_facility,
        fee_id: fee.id,
        amount: fee.amount
    })
end

=begin
r = 999..995
(r.first).downto(r.last).each do |no|
    xray_facility = XrayFacility.create!({
        code: nil,
        name: sprintf("XRAY FACILITY %03d", no),
        address1: "LINE 1",
        address2: "LINE 2",
        address3: "",
        address4: "",
        country_id: Country.find_by(code: Country::MALAYSIA_CODE).id,
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        email: sprintf("fonghy+xray%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+xray%03dp@bookdoc.com", no),
        title_id: Title.order("random()").first.id,
        icno: sprintf("ICNO%08d", no),
        mobile: sprintf("01%08d", no),
        qualification: sprintf("XRAY%03dQUALIFICATION", no),
        status: "ACTIVE",
        film_type: "DIGITAL",
        district_health_office_id: @district_health_offices.sample.id,
        xray_license_number: sprintf("XRAY%03d LICENSE NUMBER", no),
        xray_file_number: sprintf("XRAY%03d FILE NUMBER", no),
        xray_fac_flag: false,
        xray_license_tujuan: sprintf("XRAY%03d LICENSE TUJUAN", no),
        xray_license_expiry_date: DateTime.now,
        radiologist_operated: true,
        radiologist_name: sprintf("XRAY%03d RADIOLOGIST NAME", no),
        apc_year: 2019,
        apc_number: sprintf("XRAY%03d APC NUMBER", no),
        renewal_agreement_date: "2019-01-01",
        fp_device: 1,
        comment: "",
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: nil,
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    })
    xray_facility.update_code
    xray_facility.update_attributes(code: "#{xray_facility.code[0...4]}999#{no}")
    xray_facility.create_user(skip_confirmation: true, update_password: false)
    order = Order.create!({
        customerable: xray_facility,
        category: "XRAY_FACILITY_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: xray_facility,
        fee_id: fee.id,
        amount: fee.amount
    })
end

x = XrayFacility.find(1)
x.update({
    code: "X4EX999999"
})
x.user.update({
    username: "X4EX999999"
})
x = XrayFacility.find(2)
x.update({
    code: "X5EX999998"
})
x.user.update({
    username: "X5EX999998"
})
x = XrayFacility.find(3)
x.update({
    code: "X6EX999997"
})
x.user.update({
    username: "X6EX999997"
})
x = XrayFacility.find(4)
x.update({
    code: "X7EX999996"
})
x.user.update({
    username: "X7EX999996"
})
x = XrayFacility.find(5)
x.update({
    code: "X8EX999995"
})
x.user.update({
    username: "X8EX999995"
})

(1..(@sample_count || 10)).each do |no|
    town = @towns.sample

    xray_facility = XrayFacility.create!(
        code: nil,
        name: sprintf("XRAY %03d", no),
        address1: "LINE 1",
        address2: "LINE 2",
        address3: "",
        address4: "",
        country_id: Country.find_by(code: Country::MALAYSIA_CODE).id,
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        email: sprintf("fonghy+xray%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+xray%03dp@bookdoc.com", no),
        title_id: Title.order("random()").first.id,
        icno: sprintf("ICNO%08d", no),
        mobile: sprintf("01%08d", no),
        qualification: sprintf("XRAY%03dQUALIFICATION", no),
        status: "ACTIVE",
        film_type: "DIGITAL",
        district_health_office_id: @district_health_offices.sample.id,
        xray_license_number: sprintf("XRAY%03d LICENSE NUMBER", no),
        xray_file_number: sprintf("XRAY%03d FILE NUMBER", no),
        xray_fac_flag: false,
        xray_license_tujuan: sprintf("XRAY%03d LICENSE TUJUAN", no),
        xray_license_expiry_date: DateTime.now,
        radiologist_operated: true,
        radiologist_name: sprintf("XRAY%03d RADIOLOGIST NAME", no),
        apc_year: 2019,
        apc_number: sprintf("XRAY%03d APC NUMBER", no),
        renewal_agreement_date: "2019-01-01",
        fp_device: 1,
        comment: "",
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: nil,
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    )
    xray_facility.update_code
    xray_facility.create_user(skip_confirmation: true, update_password: false)
    order = Order.create!({
        customerable: xray_facility,
        category: "XRAY_FACILITY_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: xray_facility,
        fee_id: fee.id,
        amount: fee.amount
    })
end
=end

puts "x-ray facilities seeded"
@xray_facilities = XrayFacility.all