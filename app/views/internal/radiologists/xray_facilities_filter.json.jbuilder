json.results do
    json.array! @xray_facilities, :id, :code, :name
end