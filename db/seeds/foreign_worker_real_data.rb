employer = Employer.find_by(business_registration_number: "EMP999BRN")
employer.foreign_workers.create({
    name: "SINAGA SISKA NURHAYATI",
    passport_number: "AU312896",
    gender: "F",
    date_of_birth: "1999/12/09",
    arrival_date: rand(0..365*5).days.ago,
    country_id: Country.where(:code => 'IDN').first.id,
    job_type_id: JobType.order("random()").first.id,
    plks_number: sprintf("%02d", rand(0..99)),
})


puts "foreign worker(real data) seeded"