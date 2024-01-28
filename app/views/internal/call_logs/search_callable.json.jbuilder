json.array! @callables do |callable|
    # json.merge! callable.attributes
    json.id callable.id
    json.code callable.code
    json.name callable.name
end