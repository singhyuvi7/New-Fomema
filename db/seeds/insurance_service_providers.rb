# insurance service provider
[
    {code: "HOWDEN", name: "HOWDEN SDN BHD", display_name: "Howden", active: true, payment_to_code: "FGSB_CODE"},
    {code: "PROTECTMIGRANT", name: "TREKFOMEMA SDN BHD", display_name: "ProtectMigrant", active: true, payment_to_code: "TFSB_CODE"},

].each do |data|
    b = InsuranceServiceProvider.where(code: data[:code]).first_or_create
    b.update(data)
end

puts("insurance service provider seeded")
