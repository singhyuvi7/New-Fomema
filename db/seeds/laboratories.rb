# Laboratories
fee = Fee.find_by(code: "LABORATORY_REGISTRATION")

town = Town.find_by(code: "E021")
@district_health_offices = DistrictHealthOffice.all if !@district_health_offices
@ipay88 = PaymentMethod.find_by(code: "IPAY88") if !@ipay88

[
    {no: 999, code: "L7EL999999"},
    {no: 998, code: "L8EL999998"},
    {no: 997, code: "L9EL999997"},
    {no: 996, code: "L1EL999996"},
    {no: 995, code: "L2EL999995"},
].each do |row|
    no = row[:no];
    laboratory = Laboratory.create!({
        code: row[:code],
        name: sprintf("LABORATORY %03d", no),
        business_registration_number: sprintf("LAB%03dBRN", no),
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
        email: sprintf("fonghy+lab%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+lab%03dp@bookdoc.com", no),
        pic_name: sprintf("LAB %03d PIC", no),
        pic_phone: sprintf("01000002%02d", no),
        qualification: sprintf("LAB%03d QUALIFICATION", no),
        pathologist_name: "",
        nsr_number: sprintf("LAB%03dNSR", no),
        laboratory_type_id: 2,
        renewal_agreement_date: "2019-09-21",
        status: "ACTIVE",
        district_health_office_id: @district_health_offices.sample.id,
        samm_number: sprintf("LAB%03dSAMM", no),
        license: sprintf("LAB%03dLICENSE", no),
        license_year: 2019,
        web_service: true,
        web_service_passphrase: sprintf("LAB%03dWEBPASS", no),
        comment: "",
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

    laboratory.create_user(skip_confirmation: true, update_password: false)
    laboratory.user.update(password: "12345678")

    order = Order.create!({
        customerable: laboratory,
        category: "LABORATORY_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: laboratory,
        fee_id: fee.id,
        amount: fee.amount
    })
end

=begin
r = 999..995
(r.first).downto(r.last).each do |no|
    laboratory = Laboratory.create!({
        code: nil,
        name: sprintf("LABORATORY %03d", no),
        business_registration_number: sprintf("LAB%03dBRN", no),
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
        email: sprintf("fonghy+lab%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+lab%03dp@bookdoc.com", no),
        pic_name: sprintf("LAB %03d PIC", no),
        pic_phone: sprintf("01000002%02d", no),
        qualification: sprintf("LAB%03d QUALIFICATION", no),
        pathologist_name: "",
        nsr_number: sprintf("LAB%03dNSR", no),
        laboratory_type_id: 2,
        renewal_agreement_date: "2019-09-21",
        status: "ACTIVE",
        district_health_office_id: @district_health_offices.sample.id,
        samm_number: sprintf("LAB%03dSAMM", no),
        license: sprintf("LAB%03dLICENSE", no),
        license_year: 2019,
        web_service: true,
        web_service_passphrase: sprintf("LAB%03dWEBPASS", no),
        comment: "",
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
    laboratory.update_code
    laboratory.update_attributes(code: "#{laboratory.code[0...4]}999#{no}")
    laboratory.create_user(skip_confirmation: true, update_password: false)
    order = Order.create!({
        customerable: laboratory,
        category: "LABORATORY_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: laboratory,
        fee_id: fee.id,
        amount: fee.amount
    })
end

l = Laboratory.find(1)
l.update({
    code: "L7EL999999"
})
l.user.update({
    username: "L7EL999999"
})
l = Laboratory.find(2)
l.update({
    code: "L8EL999998"
})
l.user.update({
    username: "L8EL999998"
})
l = Laboratory.find(3)
l.update({
    code: "L9EL999997"
})
l.user.update({
    username: "L9EL999997"
})
l = Laboratory.find(4)
l.update({
    code: "L1EL999996"
})
l.user.update({
    username: "L1EL999996"
})
l = Laboratory.find(5)
l.update({
    code: "L2EL999995"
})
l.user.update({
    username: "L2EL999995"
})

(1..(@sample_count || 10)).each do |no|
    town = @towns.sample

    laboratory = Laboratory.create!(
        code: nil,
        name: sprintf("LAB %03d", no),
        business_registration_number: sprintf("LAB%03dBRN", no),
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
        email: sprintf("fonghy+lab%03d@bookdoc.com", no),
        email_payment: sprintf("fonghy+lab%03dp@bookdoc.com", no),
        pic_name: sprintf("LAB %03d PIC", no),
        pic_phone: sprintf("01000002%02d", no),
        qualification: sprintf("LAB%03d QUALIFICATION", no),
        pathologist_name: "",
        nsr_number: sprintf("LAB%03dNSR", no),
        laboratory_type_id: 2,
        renewal_agreement_date: "2019-09-21",
        status: "ACTIVE",
        district_health_office_id: @district_health_offices.sample.id,
        samm_number: sprintf("LAB%03dSAMM", no),
        license: sprintf("LAB%03dLICENSE", no),
        license_year: 2019,
        web_service: true,
        web_service_passphrase: sprintf("LAB%03dWEBPASS", no),
        comment: "",
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: "New request by Fong (1)",
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
        service_provider_group_id: nil
    )
    laboratory.update_code
    laboratory.create_user(skip_confirmation: true, update_password: false)
    order = Order.create!({
        customerable: laboratory,
        category: "LABORATORY_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create!({
        order_itemable: laboratory,
        fee_id: fee.id,
        amount: fee.amount
    })
end
=end

puts "laboratories seeded"