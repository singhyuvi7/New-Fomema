# employer
tmp_state = State.first
tmp_bank = Bank.first
tmp_organization = Organization.find_by(code: "KL")

employer1 = Employer.where(email: "chongwk+c01@bookdoc.com").first_or_create do |employer|
    employer.update({
        name: "QA COMP ONE",
        employer_type_id: EmployerType.where(name: "COMPANY").first.id,
        business_registration_number: "QACOMP01BRN001",
        address1: "QA COMP ONE ADDRESS LINE 1",
        address2: "QA COMP ONE ADDRESS LINE 2",
        address3: "QA COMP ONE ADDRESS LINE 3",
        country_id: Country.malaysia_id,
        state_id: tmp_state.id,
        town_id: tmp_state.towns.sample.id,
        postcode: "50000",
        phone: "0001",
        pic_name: "QA COMP ONE PIC",
        pic_phone: "0011",
        status: "ACTIVE",
        bank_id: tmp_bank.id,
        bank_account_number: "123",
        organization_id: tmp_organization.id
    })
    employer.update_code
    employer.create_user(skip_confirmation: true, password: "12345678")
end

employer2 = Employer.where(email: "chongwk+i01@bookdoc.com").first_or_create do |employer|
    employer.update({
        name: "QA INDV ONE",
        employer_type_id: EmployerType.where(name: "INDIVIDUAL").first.id,
        ic_passport_number: "800101101001",
        address1: "QA INDV ONE ADDRESS LINE 1",
        address2: "QA INDV ONE ADDRESS LINE 2",
        address3: "QA INDV ONE ADDRESS LINE 3",
        country_id: Country.malaysia_id,
        state_id: tmp_state.id,
        town_id: tmp_state.towns.sample.id,
        postcode: "46000",
        phone: "0002",
        pic_name: "QA COMP ONE PIC",
        pic_phone: "0011",
        status: "ACTIVE",
        bank_id: tmp_bank.id,
        bank_account_number: "012",
        organization_id: tmp_organization.id
    })
    employer.update_code
    employer.create_user(skip_confirmation: true, password: "12345678")
end

# radiologist

# laboratory

# xray facility

# doctor
doctor1 = Doctor.where(email: "chongwk+dr1@bookdoc.com").first_or_create do |doctor|
    doctor.update({
        name: "QA DOCTOR ONE",
        clinic_name: "QA DOCTOR ONE CLINIC",
        icno: "800101101002",
        address1: "QA DOCTOR ONE ADDRESS LINE 1",
        address2: "QA DOCTOR ONE ADDRESS LINE 2",
        address3: "QA DOCTOR ONE ADDRESS LINE 3",
        country_id: Country.malaysia_id,
        state_id: tmp_state.id,
        town_id: tmp_state.towns.sample.id,
        postcode: "50000",
        phone: "1000",
        qualification: "DOCTORATE",
        apc_year: 2019,
        apc_number: "001",
        fp_device: 0,
        quota: 500,
        quota_used: 0,
        quota_modifier: 0,
        xray_facility_id: xray_facility1.id,
        laboratory_id: laboratory1.id,
        pairing_options: {"xray_facilities":[],"laboratories":[]},
        male_rate: 60,
        female_rate: 60,
        bank_payment_id: '800101101002',
        status: "ACTIVE"
    })
    doctor.update_code
    doctor.activate
    doctor.create_user
end