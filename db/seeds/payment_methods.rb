# payment methods
[
    {code: "IPAY88", name: "iPay88", category: "IN", payment_code: "CREDIT", is_main: true, active: false, use_at: 'EXTERNAL'},
    {code: "BANKDRAFT", name: "Bank Draft", category: "IN", payment_code: "BD", is_main: false},
    {code: "OUT_CASHORDER", name: "Cash Order", category: "OUT", payment_code: "CO", is_main: false, active: true, use_at: 'INTERNAL'},
    {code: "OUT_CHEQUE", name: "Cheque", category: "OUT", payment_code: "CHQ", is_main: false, active: true, use_at: 'INTERNAL'},
    {code: "OUT_GIROROC", name: "GIRO ROC", category: "OUT", payment_code: "GIRO", is_main: false, active: true, use_at: 'INTERNAL'},
    {code: "OUT_GIRONEWIC", name: "GIRO New IC", category: "OUT", payment_code: "GIRO", is_main: false, active: true, use_at: 'INTERNAL'},
    {code: "OUT_GIROPASSPORT", name: "GIRO Passport", category: "OUT", payment_code: "GIRO", is_main: false, active: true, use_at: 'INTERNAL'},
    {code: "CIMB_CLICKS", name: "CIMB Clicks", category: "IN", payment_code: "GIRO", is_main: false},

    {code: "ATM", name: "ATM",category: "IN", is_main: false, active: false},
    {code: "BANK_SLIP", name: "Bank Slip",category: "IN", is_main: false, active: false},
    {code: "CASH", name: "Cash",category: "IN", is_main: false, active: false},
    {code: "CDM", name: "CDM",category: "IN", is_main: false, active: false},
    {code: "COUNTER_BANK_IN", name: "Counter Bank-In",category: "IN", is_main: false, active: false},
    {code: "CREDIT_CARD", name: "Credit Card",category: "IN", is_main: false, active: false},
    {code: "CREDIT_CARD_IPAY88", name: "Credit Card-iPay88",category: "IN",payment_code: "CREDIT", is_main: true, active: true},
    {code: "CREDIT_CARD_PUBLIC_BANK", name: "Credit Card-Public Bank",category: "IN",payment_code: "CREDIT", is_main: true, active: true},
    {code: "DEBIT_CARD", name: "Debit Card",category: "IN", is_main: false, active: false},
    {code: "DEBIT_CARD_IPAY88", name: "Debit Card-iPay88",category: "IN",payment_code: "DEBIT", is_main: true, active: true},
    {code: "DEBIT_CARD_PUBLIC_BANK", name: "Debit Card-Public Bank",category: "IN",payment_code: "DEBIT", is_main: true, active: true},
    {code: "FPX", name: "FPX",category: "IN", is_main: false, active: false},
    {code: "FOC", name: "Free Of Charge",category: "IN", is_main: false, active: false},
    {code: "INTERNET", name: "Internet",category: "IN", is_main: false, active: false},
    {code: "ONLINE_BANKING", name: "Online Banking",category: "IN", is_main: false, active: false},
    {code: "POS_MALAYSIA", name: "Pos Malaysia",category: "IN", is_main: false, active: false},
    {code: "POSTAL_ORDER", name: "Postal Order",category: "IN", is_main: false, active: false},
    {code: "TT", name: "TT",category: "IN", is_main: false, active: false},
    {code: "MONEY_ORDER", name: "Money Order",category: "IN", is_main: false, active: false},
    {code: "OTHERS", name: "Others",category: "IN", is_main: false, active: false},

    {code: "IPAY_EWALLET", name: "iPay88 - Ewallet",category: "IN", payment_code: "EWALLET", is_main: true, use_at: 'EXTERNAL'},
    {code: "IPAY_CC", name: "iPay88 - Credit Card",category: "IN", payment_code: "CREDIT", is_main: true, use_at: 'EXTERNAL'},
    {code: "IPAY_FPX_B2C", name: "iPay88 - FPX B2C",category: "IN", payment_code: "FPXTT", is_main: true, use_at: 'EXTERNAL'},
    {code: "IPAY_FPX_B2B", name: "iPay88 - FPX B2B",category: "IN", payment_code: "FPXTT", is_main: true, use_at: 'EXTERNAL'},

    {code: "MAYBANK_QR_PAY", name: "Maybank QR Pay",category: "IN", payment_code: "MBBQR", is_main: true, active: true},
    {code: "OCBC_DUITNOW_QR", name: "OCBC DUITNOW QR",category: "IN", payment_code: "OCBCQR", is_main: true, active: true},

    {code: "SWIPE", name: "Swipe", category: "IN", payment_code: "CREDIT", is_main: false, active: false, use_at: 'EXTERNAL'},
    {code: "SWIPE_EWALLET", name: "Swipe - Ewallet",category: "IN", payment_code: "EWALLET", is_main: false, use_at: 'EXTERNAL'},
    {code: "SWIPE_CC", name: "Swipe - Credit Card",category: "IN",payment_code: "CREDIT", is_main: false, use_at: 'EXTERNAL'},
    {code: "SWIPE_FPX_B2C", name: "Swipe - FPX B2C (Retail)",category: "IN",payment_code: "FPXTT", is_main: false, use_at: 'EXTERNAL'},
    {code: "SWIPE_FPX_B2B", name: "Swipe - FPX B2B (Corporate)",category: "IN",payment_code: "FPXTT", is_main: false, use_at: 'EXTERNAL'},

    {code: "PAYNET_FPX_B2C", name: "FPX B2C (Individual)",category: "IN",payment_code: "FPXTT", is_main: true, use_at: 'EXTERNAL'},
    {code: "PAYNET_FPX_B2B", name: "FPX B2B (Corporate)",category: "IN",payment_code: "FPXTT", is_main: true, use_at: 'EXTERNAL'},

    {code: "BOLEH", name: "BolehPay", category: "IN", payment_code: "BPAY", is_main: false, active: false, use_at: 'EXTERNAL'},

].each do |data|
    fs = PaymentMethod.where(:code => data[:code]).first_or_create
    fs.update(data)
end
puts("payment methods seeded")
@ipay88 = PaymentMethod.find_by(code: "IPAY88")
@swipe = PaymentMethod.find_by(code: "SWIPE")
@fpx = PaymentMethod.find_by(code: "PAYNET")
@boleh = PaymentMethod.find_by(code: "BOLEH")