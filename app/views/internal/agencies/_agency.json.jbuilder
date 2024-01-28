json.extract! agency, :id, :code, :name, :business_registration_number, :postcode, :address1, :address2, :address3, :address4

json.state do
    json.merge! agency.state&.attributes
end

json.town do
    json.merge! agency.town&.attributes
end