[
    {code: '2', name: 'Credit Card (MYR)', payment_code: 'CREDIT'},
    {code: '210', name: 'Boost Wallet', payment_code: 'EWALLET'},
    {code: '538', name: 'Touch N Go', payment_code: 'EWALLET'},
    {code: '6', name: 'Maybank2U', payment_code: 'FPXTT'},
    {code: '103', name: 'Affin Online', payment_code: 'FPXTT'},
    {code: '20', name: 'CIMB Click', payment_code: 'FPXTT'},
    {code: '102', name: 'Bank Rakyat Internet Banking', payment_code: 'FPXTT'},
    {code: '14', name: 'RHB Online', payment_code: 'FPXTT'},
    {code: '8', name: 'Alliance Online', payment_code: 'FPXTT'},
    {code: '15', name: 'Hong Leong Online', payment_code: 'FPXTT'},
    {code: '134', name: 'Bank Islam', payment_code: 'FPXTT'},
    {code: '10', name: 'AmOnline', payment_code: 'FPXTT'},
    {code: '198', name: 'HSBC Online Banking', payment_code: 'FPXTT'},
    {code: '124', name: 'BSN Online', payment_code: 'FPXTT'},
    {code: '199', name: 'Kuwait Finance House', payment_code: 'FPXTT'},
    {code: '166', name: 'Bank Muamalat', payment_code: 'FPXTT'},
    {code: '167', name: 'OCBC', payment_code: 'FPXTT'},
    {code: '168', name: 'Standard Chartered Bank', payment_code: 'FPXTT'},
    {code: '152', name: 'UOB', payment_code: 'FPXTT'},
    {code: '31', name: 'Public Bank Online', payment_code: 'FPXTT'}
].each do |data|
    fs = Ipay88Type.where(:code => data[:code]).first_or_create
    fs.update(data)
end 
puts("ipay88 types seeded")
