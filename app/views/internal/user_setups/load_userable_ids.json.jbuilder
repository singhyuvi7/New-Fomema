json.results @userable_ids do |id|
    json.id id.id
    json.text id.name
end