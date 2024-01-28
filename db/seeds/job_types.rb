# job types
['AGRICULTURE', 'CONSTRUCTION', 'DOMESTIC', 'MANUFACTURING', 'PLANTATION', 'SERVICE'].each do |jobtype|
    JobType.where(name: jobtype).first_or_create
end
puts("job types seeded")