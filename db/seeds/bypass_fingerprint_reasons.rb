# bypass fingerprint reasons
[
    {code: "OTHER", description: "Others"},
    {code: "BT", description: "Below Threshold"},
    {code: "MNF", description: "Matching Not Found"},
    {code: "CC", description: "Change Coupling"},
    {code: "EC", description: "Expired Case"},
    {code: "PHTPA", description: "Pending HTP Action"},
    {code: "PFIOTA", description: "Pending FIOT Action"},
].each do |data|
    b = BypassFingerprintReason.where(code: data[:code]).first_or_create
    b.update(data)
end

puts("bypass fingerprint reasons seeded")
