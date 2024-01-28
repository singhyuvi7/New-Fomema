json.merge! xray_facility.attributes

json.state do
    json.merge! xray_facility.state.attributes
end

json.town do
    json.merge! xray_facility.town.attributes
end