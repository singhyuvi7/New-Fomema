json.merge! doctor.attributes

json.state do
    json.merge! doctor.state.attributes
end

json.town do
    json.merge! doctor.town.attributes
end