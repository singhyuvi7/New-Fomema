# agency license categories
[
    {name: "A"},
    {name: "B"},
    {name: "C"}
].each do |data|
    b = AgencyLicenseCategory.where(name: data[:name]).first_or_create
    b.update(data)
end

puts("agency license categories")