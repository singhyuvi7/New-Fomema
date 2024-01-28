# amendment reasons
[
    {code: "OTHER", name: "Other"}, # 4
    {code: "NAME", name: "Name"},
    {code: "DOB", name: "DOB"},
    {code: "COUNTRY", name: "Country"},
    {code: "PASSPORT", name: "Passport No."}, # 1
    {code: "JOB_TYPE", name: "Job Type"},
    {code: "GENDER", name: "Gender"},
    {code: "INPUT_ERROR", name: "Input error"}, # 2
    {code: "AUTHORITY_REQUEST", name: "Request by authority"}, # 3
    {code: "CHANGE_NEW_PASSPORT", name: "Change New Passport"},
    {code: "ADDRESS", name: "Address"},
].each do |data|
    AmendmentReason.create!(data)
end
puts("amendment reasons seeded")