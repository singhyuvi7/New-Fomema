# call log case types
[
    {code: "OTHER", description: "Others"},
    {code: "NONCOMP", description: "Non-Compliance"},
    {code: "LATESUB", description: "Late Submission"},
    {code: "REPEAT", description: "Repeat"},
    {code: "DIGITAL", description: "Digital Issue"},
    {code: "AUDITRAD", description: "Audit Radiograph"},
    {code: "COMPLAINT", description: "Complaint"},
].each do |data|
    b = CallLogCaseType.where(code: data[:code]).first_or_create
    b.update(data)
end

puts("call log case types seeded")
