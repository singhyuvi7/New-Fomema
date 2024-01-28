# name of xray license purposes
[
    {name: "MENSTOR"},
    {name: "MENJUAL"},
    {name: "MENGGUNA"},
    {name: "MEMBELI"},

].each do |data|
    XrayLicensePurposes.create!(data)
end
puts("name of xray license purposes seeded")