# name of associations
[
    {code: "MMA", name: "Malaysian Medical Association (MMA)"},
    {code: "PERDIM", name: "Pertubuhan Doktor-Doktor Islam Malaysia (PERDIM)"},
    {code: "FPMPAM", name: "Federation of Private Medical Practitioners’ Association Malaysia (FPMPAM)"},
    {code: "PMPS", name: "Penang Medical Practitioners’ Society (PMPS)"},
    {code: "MPCAM", name: "Medical Practitioners Coalition Association of Malaysia (MPCAM)"},
    {code: "PMPASKL", name: "Private Medical Practitioner’s Association of Selangor and Kuala Lumpur (PMPASKL)"},
    {code: "PMAM", name: "Persatuan Makmal Akreditasi Malaysia (PMAM)"},
    {code: "AMM", name: "Academy of Medicine of Malaysia (AMM)"},
    {code: "AFPM", name: "Academy of Family Physicians of Malaysia(AFPM)"},
    {code: "MRS", name: "Malaysia Radiologi Society (MRS)"},
    {code: "IMAM", name: "Persatuan Perubatan Islam Malaysia(IMAM)"},

].each do |data|
    Association.create!(data)
end
puts("name of associations seeded")