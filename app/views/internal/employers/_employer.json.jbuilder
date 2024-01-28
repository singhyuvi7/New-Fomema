json.extract! employer, :id, :code, :name, :business_registration_number, :ic_passport_number, :postcode, :address1, :address2, :address3, :address4

json.employer_type do
    json.name employer.employer_type&.name
end

json.state do
    json.merge! employer.state&.attributes
end

json.town do
    json.merge! employer.town&.attributes
end