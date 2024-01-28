# Employers
town = Town.find_by(code: "E021")
r = 999..995
(r.first).downto(r.last).each do |no|
    employer = Employer.create!(
        code: nil,
        business_registration_number: sprintf("EMP%03dBRN", no),
        ic_passport_number: nil,
        name: sprintf("EMPLOYER %03d", no),
        address1: "LINE 1",
        address2: "LINE 2",
        address3: nil,
        address4: nil,
        country_id: Country.find_by(code: Country::MALAYSIA_CODE).id,
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("0100000%03d", no),
        fax: sprintf("0100001%03d", no),
        email: sprintf("fonghy+emp%03d@bookdoc.com", no),
        pic_name: sprintf("EMPLOYER %03d PIC NAME", no),
        pic_phone: sprintf("0100002%03d", no),
        comment: "",
        employer_type_id: 2,
        bad_payment: nil,
        status: 'ACTIVE',
        approval_status: "NEW_APPROVED",
        blacklisted: false,
        blacklisted_at: nil,
        # assigned_to: nil,
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: nil,
        updated_by: nil
    )
    employer.update_code
    employer.create_user(skip_confirmation: true)
end

(1..(@sample_count || 10)).each do |no|
    town = @towns.sample
    employer = Employer.create!(
        code: nil,
        business_registration_number: sprintf("EMP%03dBRN", no),
        ic_passport_number: nil,
        name: sprintf("EMPLOYER %03d", no),
        address1: "LINE 1",
        address2: "LINE 2",
        address3: nil,
        address4: nil,
        country_id: Country.find_by(code: Country::MALAYSIA_CODE).id,
        state_id: town.state_id,
        postcode: "68000",
        town_id: town.id,
        phone: sprintf("01000000%02d", no),
        fax: sprintf("01000001%02d", no),
        email: sprintf("fonghy+emp%03d@bookdoc.com", no),
        pic_name: sprintf("EMPLOYER %03d PIC NAME", no),
        pic_phone: sprintf("01000002%02d", no),
        comment: "",
        employer_type_id: 2,
        bad_payment: nil,
        status: 'ACTIVE',
        approval_status: "NEW_APPROVED",
        blacklisted: false,
        blacklisted_at: nil,
        # assigned_to: nil,
        created_at: DateTime.now,
        updated_at: DateTime.now,
        created_by: nil,
        updated_by: nil
    )
    employer.update_code
    employer.create_user(skip_confirmation: true)
end

puts "employers seeded"