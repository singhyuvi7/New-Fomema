# laboratory types
['FULL', 'PARTIAL', 'COLLECTION'].each do |laboratorytype|
    LaboratoryType.where(name: laboratorytype).first_or_create
end
puts("laboratory types seeded")