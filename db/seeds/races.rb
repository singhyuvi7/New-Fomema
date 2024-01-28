# fees
[
    {name: "MALAY"},
    {name: "CHINESE"},
    {name: "INDIA"},
    {name: "SENOI"},
    {name: "MALAYU PROTO"},
    {name: "KADAZANDUSUN"},
    {name: "RUNGUS"},
    {name: "BAJAU"},
    {name: "BAJAU LAUT"},
    {name: "MURUT"},
    {name: "LUNDAYEH"},
    {name: "ORANG SUNGAI"},
    {name: "IRANUN"},
    {name: "BIDAYUH"},
    {name: "MELANAU"},
    {name: "ORANG ULU"},
    {name: "NEGRITO"},
    {name: "SIKH"},
    {name: "OTHERS"},
    {name: "NOT APPLICABLE"},
].each do |data|
    fs = Race.where(:name => data[:name]).first_or_create
    fs.update(data)
end
puts("races seeded")