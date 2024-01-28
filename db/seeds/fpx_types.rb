[
    {code: '01', name: 'B2C', payment_code: 'FPXTT'},
    {code: '02', name: 'B2B', payment_code: 'FPXTT'}
].each do |data|
    fs = FpxType.where(:code => data[:code]).first_or_create
    fs.update(data)
end 
puts("fpx types seeded")