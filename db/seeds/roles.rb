# Roles

@internalPasswordPolicy = PasswordPolicy.find_by({
    name: "Internal User"
})
[
    {category: "Organization", code: "OBSOLETE", name: "OBSOLETE"},
    {category: "Organization", code: "BRANCH_DEC", name: "BRANCH DATA ENTRY CLERK"},
    {category: "Organization", code: "BRANCH_EXECUTIVE", name: "BRANCH EXECUTIVE"},
    {category: "Organization", code: "BRANCH_MANAGER", name: "BRANCH MANAGER"},
    {category: "Organization", code: "BRANCH_OIC", name: "BRANCH OFFICER IN CHARGE"},
    {category: "Organization", code: "CEO ", name: "CHIEF EXECUTIVE OFFICER"},
    {category: "Organization", code: "CS_EXECUTIVE", name: "CUSTOMER SERVICE EXECUTIVE"},
    {category: "Organization", code: "FINANCE_EXTERNAL_AUDITOR", name: "FINANCE EXTERNAL AUDITOR"},
    {category: "Organization", code: "FINANCE_CLERK", name: "FINANCE CLERK"},
    {category: "Organization", code: "FINANCE_EXECUTIVE", name: "FINANCE EXECUTIVE"},
    {category: "Organization", code: "FINANCE_MANAGER", name: "FINANCE MANAGER"},
    {category: "Organization", code: "HCM_EXECUTIVE", name: "HCM EXECUTIVE"},
    {category: "Organization", code: "INSPECTORATE_EXECUTIVE", name: "INSPECTORATE EXECUTIVE"},
    {category: "Organization", code: "IT_ADMIN", name: "IT ADMINISTRATOR"},
    {category: "Organization", code: "IT_SUPPORT", name: "IT SUPPORT"},
    {category: "Organization", code: "MEDICAL_CLERK", name: "MEDICAL CLERK"},
    {category: "Organization", code: "MEDICAL_MLE", name: "MEDICAL MLE"},
    {category: "Organization", code: "MEDICAL_MO", name: "MEDICAL OFFICER"},
    {category: "Organization", code: "MEDICAL_SENIOR_MLE", name: "MEDICAL SENIOR MLE"},
    {category: "Organization", code: "MSPD_ASSISTANT_MANAGER", name: "MSPD ASSISTANT MANAGER"},
    {category: "Organization", code: "MSPD_CLERK", name: "MSPD CLERK"},
    {category: "Organization", code: "MSPD_EXECUTIVE", name: "MSPD EXECUTIVE"},
    {category: "Organization", code: "MSPD_MANAGER", name: "MSPD MANAGER"},
    {category: "Organization", code: "MSPD_STATISTICIAN", name: "MSPD STATISTICIAN"},
    {category: "Organization", code: "OPERATION_MANAGER", name: "OPERATION MANAGER"},
    {category: "Organization", code: "PCR", name: "PCR"},
    {category: "Organization", code: "BRANCH_RM", name: "BRANCH REGIONAL MANAGER"},
    {category: "Organization", code: "XQCC_ASSISTANT_MANAGER", name: "XQCC_ASSISTANT_MANAGER"},
    {category: "Organization", code: "XQCC_EXECUTIVE", name: "XQCC_EXECUTIVE"},
    {category: "Organization", code: "XQCC_MO", name: "XQCC MEDICAL OFFICER"},
    {category: "Organization", code: "XQCC_MLE", name: "XQCC MLE"},
    {category: "Organization", code: "XQCC_RADIOGRAPHER", name: "XQCC RADIOGRAPHER"},
    {category: "Organization", code: "SYSTEM", name: "SYSTEM"},
].each do |data|
    r = Role.where({
        category: data[:category],
        code: data[:code],
    }).first_or_create
    r.update!(data.merge({
        status: Role::STATUS_ACTIVE,
        site: ENV['SUBDOMAIN_NIOS'] || "NIOS",
        password_policy_id: @internalPasswordPolicy.id,
    }))
end

@externalPasswordPolicy = PasswordPolicy.find_by({
    name: "External User"
})
[
    {category: "Doctor", code: "DOCTOR", name: "DOCTOR", site: ENV["SUBDOMAIN_MERTS"]},
    {category: "Radiologist", code: "RADIOLOGIST", name: "RADIOLOGIST", site: ENV["SUBDOMAIN_MERTS"]},
    {category: "Laboratory", code: "LABORATORY", name: "LABORATORY", site: ENV["SUBDOMAIN_MERTS"]},
    {category: "XrayFacility", code: "XRAY_FACILITY", name: "XRAY_FACILITY", site: ENV["SUBDOMAIN_MERTS"]},
    {category: "Employer", code: "EMPLOYER", name: "EMPLOYER", site: ENV["SUBDOMAIN_PORTAL"]},
    {category: "Employer", code: "EMPLOYER_SUPPLEMENTAL", name: "EMPLOYER_SUPPLEMENTAL", site: ENV["SUBDOMAIN_PORTAL"]},
    {category: "Agency", code: "AGENCY_UNPAID", name: "AGENCY UNPAID", site: ENV["SUBDOMAIN_PORTAL"]},
    {category: "Agency", code: "AGENCY", name: "AGENCY", site: ENV["SUBDOMAIN_PORTAL"]},
].each do |data|
    r = Role.where({
        category: data[:category],
        code: data[:code],
    }).first_or_create
    r.update!(data.merge(
        status: Role::STATUS_ACTIVE,
        password_policy_id: @externalPasswordPolicy.id,
    ))
end
puts "roles seeded"