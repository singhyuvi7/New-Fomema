json.merge! state.attributes
json.towns do
    json.array! state.towns
end