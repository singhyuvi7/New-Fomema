# organizations (branches)

# root
fomema = Organization.where(code: "FOMEMA", org_type: "HEADQUARTER").first_or_create

tmp_state = State.find(4)
# branches -- :name, :address1, :state_id, :town_id, :postcode, :phone, :email
[
    {
        code: 'PT', 
        org_type: "BRANCH", 
        name: "WEBPORTAL", 
        address1: "WEBPORTAL", 
        state_id: tmp_state.id, 
        town_id: tmp_state.towns.sample.id, 
        phone: "0100000001", 
        email: "FONGHY+ORG001@BOOKDOC.COM", 
        postcode: "50000"
    }, {
        code: 'HQ', 
        org_type: "BRANCH", 
        name: "HEAD QUARTERS", 
        address1: "Lot 49 & 51,", 
        address2: "Jalan Kampung Pandan", 
        address3: "55100 Kuala Lumpur", 
        state_id: tmp_state.id, 
        town_id: tmp_state.towns.sample.id, 
        phone: "0100000001", 
        email: "FONGHY+ORG002@BOOKDOC.COM", 
        postcode: "50000"
    }, {
        code: 'KL', 
        org_type: "BRANCH", 
        name: "KUALA LUMPUR", 
        address1: "MENARA TAKAFUL MALAYSIA", 
        address2: "LEVEL 1, NO. 4, JALAN SULTAN SULAIMAN", 
        state_id: tmp_state.id, 
        town_id: tmp_state.towns.sample.id, 
        phone: "0100000001", 
        email: "FONGHY+ORG003@BOOKDOC.COM", 
        postcode: 50400
    },
].each do |data|
    o = Organization.where(code: data[:code]).first_or_create
    o.update(data)
end

# warehouse
kl_branch = Organization.find_by(code: "KL")
[
    {org_type: "WAREHOUSE", name: "KL WAREHOUSE", address1: "Suite 3.02, 3rd Floor,Dataran Hamodal Block A,Jalan Bersatu 13/4, Section 13,46200 Petaling Jaya,Selangor."},
].each do |data|
    o = Organization.where(parent_id: kl_branch.id, org_type: "WAREHOUSE").first_or_create
    o.update(data)
end

=begin
tempTown = Town.find_by(code: '4001')
hq = Organization.create!({
    code: 'HQ',
    name: 'FOMEMA HQ',
    org_type: 'HEADQUARTER',
    address1: 'HQ ADDR LINE 1',
    address2: 'ADDR LINE 2',
    address3: 'ADDR LINE 3',
    state_id: tempTown.state_id,
    town_id: tempTown.id,
    phone: '030000001',
    fax: '030000001',
    email: 'fomema+hq@bookdoc.com',
})

online_data = {
    parent_id: hq.id,
    code: 'ONLINE',
    name: 'ONLINE BRANCH',
    org_type: 'BRANCH',
    address1: 'ONLINE ADDR LINE 1',
    address2: 'ADDR LINE 2',
    address3: 'ADDR LINE 3',
    state_id: tempTown.state_id,
    town_id: tempTown.id,
    phone: '030000002',
    fax: '030000002',
    email: 'fomema+online@bookdoc.com',
}
onlineOrg = Organization.create!(online_data)
online_data[:parent_id] = onlineOrg.id
online_data[:code] = "#{online_data[:code]}_WAREHOUSE"
online_data[:name] = "#{online_data[:name]} WAREHOUSE"
online_data[:org_type] = "WAREHOUSE"
online_data[:email] = "fomema+online-warehouse@bookdoc.com"
Organization.create!(online_data)

tempTown = Town.find_by(code: '4001')
selangor_data = {
    parent_id: hq.id,
    code: 'SELANGOR',
    name: 'SELANGOR BRANCH',
    org_type: 'BRANCH',
    address1: 'SELANGOR ADDR LINE 1',
    address2: 'ADDR LINE 2',
    address3: 'ADDR LINE 3',
    state_id: tempTown.state_id,
    town_id: tempTown.id,
    phone: '030000003',
    fax: '030000003',
    email: 'fomema+selangor@bookdoc.com',
}
selangorOrg = Organization.create!(selangor_data)
selangor_data[:parent_id] = selangorOrg.id
selangor_data[:code] = "#{selangor_data[:code]}_WAREHOUSE"
selangor_data[:name] = "#{selangor_data[:name]} WAREHOUSE"
selangor_data[:org_type] = "WAREHOUSE"
selangor_data[:email] = "fomema+selangor-warehouse@bookdoc.com"
Organization.create!(selangor_data)

Organization.create!({
    code: 'PT',
    name: 'WEBPORTAL',
    org_type: 'BRANCH',
    address1: 'WEBPORTAL',
    email: 'fonghy+pt@bookdoc.com',
})
=end
puts("organizations (branches) seeded")