json.merge! laboratory.attributes

json.state do
    json.merge! laboratory.state.attributes
end

json.town do
    json.merge! laboratory.town.attributes
end