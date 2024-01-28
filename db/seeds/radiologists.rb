# radiologists
fee = Fee.find_by(code: "RADIOLOGIST_REGISTRATION")

town = Town.find_by(code: "E021")

r = 999..995
(r.first).downto(r.last).each do |no|
    @radiologist = Radiologist.create!({
        code: nil,
        name: sprintf("RADIOLOGIST %03d", no),
        title_id: Title.order("random()").first.id,
        icno: sprintf("80010101%04d", no),
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
        mobile: sprintf("01000002%02d", no),
        email: sprintf("fonghy+radio%03d@bookdoc.com", no),
        qualification: sprintf("RADIO%03dQUALIFICATION", no),
        status: "ACTIVE",
        is_panel_xray_facility: false,
        district_health_office_id: @district_health_offices.sample.id,
        is_pcr: nil,
        apc_year: 2019,
        apc_number: sprintf("RADIO%03d APC NUMBER", no),
        nsr_number: sprintf("RADIO%03d NSR NUMBER", no),
        renewal_agreement_date: DateTime.now,
        comment: "",
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: "New request by Fong (1)",
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
    })
    @radiologist.update_code
    @radiologist.create_user(skip_confirmation: true, update_password: false)
    order = Order.create({
        customerable: @radiologist,
        category: "RADIOLOGIST_REGISTRATION",
        date: Time.now,
        amount: fee.amount,
        payment_method_id: @ipay88.id,
        status: "PAID"
    })
    order.order_items.create({
        order_itemable: @radiologist,
        fee_id: fee.id,
        amount: fee.amount
    })
end

(1..(@sample_count || 10)).each do |no|
    town = @towns.sample
    is_panel_xray_facility = rand(0..1) > 0

    radiologist = Radiologist.create!(
        code: nil,
        name: sprintf("RADIO %03d", no),
        title_id: Title.order("random()").first.id,
        icno: sprintf("80010101%04d", no),
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
        mobile: sprintf("01000002%02d", no),
        email: sprintf("fonghy+radio%03d@bookdoc.com", no),
        qualification: sprintf("RADIO%03dQUALIFICATION", no),
        status: "ACTIVE",
        is_panel_xray_facility: is_panel_xray_facility,
        district_health_office_id: @district_health_offices.sample.id,
        is_pcr: nil,
        apc_year: 2019,
        apc_number: sprintf("RADIO%03d APC NUMBER", no),
        nsr_number: sprintf("RADIO%03d NSR NUMBER", no),
        renewal_agreement_date: DateTime.now,
        comment: "",
        registration_approved_at: DateTime.now,
        activated_at: DateTime.now,
        approval_status: "NEW_APPROVED",
        approval_remark: "New request by Fong (1)",
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: 1,
        updated_by: 1,
    )
    radiologist.update_code
    radiologist.create_user(skip_confirmation: true, update_password: false)
    if !is_panel_xray_facility
        order = Order.create({
            customerable: radiologist,
            category: "RADIOLOGIST_REGISTRATION",
            date: Time.now,
            amount: fee.amount,
            payment_method_id: @ipay88.id,
            status: "PAID"
        })
        order.order_items.create({
            order_itemable: radiologist,
            fee_id: fee.id,
            amount: fee.amount
        })
    end
    if is_panel_xray_facility
        (1..rand(1..3)).each do |no2|
            PanelRadiologist.first_or_create({
                xray_facility_id: @xray_facilities.sample.id,
                radiologist_id: radiologist.id
            })
        end
    end
end
puts "radiologists seeded"