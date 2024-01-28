# fw_verification
[
    {code: "SHAPE_FACE", name: "Shape of face", status: "ACTIVE"},
    {code: "SIZE_FOREHEAD", name: "Size of forehead", status: "ACTIVE"},
    {code: "SHAPE_NOSE", name: "Shape of nose (*)", status: "ACTIVE"},
    {code: "DISTANCE_TWO_EYES", name: "Distance between the two(2) eyes (*)", status: "ACTIVE"},
    {code: "SHAPE_LIPS", name: "Shape of lips", status: "ACTIVE"},
    {code: "SHAPE_EARS", name: "Shape of ears", status: "ACTIVE"},
    {code: "SPECIAL_MARKS", name: "Special marks (i.e mole/scar/birthmarks)", status:"ACTIVE"},
    {code: "SIMILARITY_FW", name: "Similarity of foreign worker's signature with that of passport bearer", status:"ACTIVE"},
].each do |data|
    FwVerificationPar.create!(data)
end
puts("fw verification seeded")