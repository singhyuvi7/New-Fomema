[
    {code: "1", name: "JOHOR", long_name: "JOHOR DARUL TAKZIM"},
    {code: "2", name: "KEDAH", long_name: "KEDAH DARUL AMAN"},
    {code: "3", name: "KELANTAN", long_name: "KELANTAN DARUL NAIM"},
    {code: "4", name: "KUALA LUMPUR", long_name: "KUALA LUMPUR"},
    {code: "5", name: "MELAKA", long_name: "MELAKA"},
    {code: "6", name: "NEGERI SEMBILAN", long_name: "NEGERI SEMBILAN DARUL KHUSUS"},
    {code: "7", name: "PAHANG", long_name: "PAHANG DARUL MAKMUR"},
    {code: "8", name: "PERAK", long_name: "PERAK DARUL RIDZUAN"},
    {code: "9", name: "PERLIS", long_name: "PERLIS INDRA KAYANGAN"},
    {code: "A", name: "PULAU PINANG", long_name: "PULAU PINANG"},
    {code: "B", name: "SABAH", long_name: "SABAH"},
    {code: "C", name: "SARAWAK", long_name: "SARAWAK"},
    {code: "D", name: "TERENGGANU", long_name: "TERENGGANU DARUL IMAN"},
    {code: "E", name: "SELANGOR", long_name: "SELANGOR DARUL EHSAN"},
    {code: "F", name: "PUTRAJAYA", long_name: "PUTRAJAYA"},
    {code: "G", name: "LABUAN", long_name: "LABUAN"}
].each do |state_data|
    State.create!(state_data)
end

puts "States seeded"