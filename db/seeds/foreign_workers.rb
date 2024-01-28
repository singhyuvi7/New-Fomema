Employer.where("id > 5").order(:id).limit(5).all.each_with_index do |employer, idx|
    employer_no = idx + 1
    (1..50).each do |worker_number|
        employer.foreign_workers.create({
            name: sprintf("WORKER %03d %03d", employer_no, worker_number),
            passport_number: sprintf("PASSPORT%03d%03d", employer_no, worker_number),
            gender: ["F", "M"][rand(0..1)],
            date_of_birth: rand(16*365..50*365).days.ago,
            arrival_date: rand(0..365*5).days.ago,
            country_id: Country.order("random()").first.id,
            job_type_id: JobType.order("random()").first.id,
            plks_number: sprintf("%02d", rand(0..99)),
        })
    end
end

employer_no = 999
employer = Employer.find_by(business_registration_number: "EMP999BRN")
(1..20).each do |worker_number|
    employer.foreign_workers.create({
        name: sprintf("WORKER %03d %03d", employer_no, worker_number),
        passport_number: sprintf("PASSPORT%03d%03d", employer_no, worker_number),
        gender: ["F", "M"][rand(0..1)],
        date_of_birth: rand(16*365..50*365).days.ago,
        arrival_date: rand(0..365*5).days.ago,
        country_id: Country.order("random()").first.id,
        job_type_id: JobType.order("random()").first.id,
        plks_number: sprintf("%02d", rand(0..99)),
    })
end

puts "foreign workers seeded"