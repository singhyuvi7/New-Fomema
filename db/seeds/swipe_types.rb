[
    {code: '1', name: 'Credit Card', payment_code: 'CREDIT'},
    {code: '2', name: 'eWallet', payment_code: 'EWALLET'},
    {code: '3', name: 'FPX B2B', payment_code: 'FPXTT'},
    {code: '4', name: 'FPX B2C', payment_code: 'FPXTT'}

].each do |data|
    fs = SwipeType.where(:code => data[:code]).first_or_create
    fs.update(data)
end 
puts("Swipe types seeded")
