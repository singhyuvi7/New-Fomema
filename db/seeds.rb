# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if ENV["file"]
    puts "file parameter detected, seeding #{ENV["file"]}"
    load File.join(Rails.root, 'db', 'seeds', "#{ENV["file"]}.rb")
    return
end

puts("#{Rails.env} environment")

load File.join(Rails.root, 'db', 'seeds', 'system_configurations.rb')
load File.join(Rails.root, 'db', 'seeds', 'employer_types.rb')
load File.join(Rails.root, 'db', 'seeds', 'laboratory_types.rb')
load File.join(Rails.root, 'db', 'seeds', 'payment_methods.rb')
load File.join(Rails.root, 'db', 'seeds', 'password_policies.rb')
load File.join(Rails.root, 'db', 'seeds', 'roles.rb')
load File.join(Rails.root, 'db', 'seeds', 'role_permissions.rb')
load File.join(Rails.root, 'db', 'seeds', 'fees.rb')
load File.join(Rails.root, 'db', 'seeds', 'countries.rb')
load File.join(Rails.root, 'db', 'seeds', 'states.rb')
load File.join(Rails.root, 'db', 'seeds', 'towns.rb')
load File.join(Rails.root, 'db', 'seeds', 'todos.rb')
load File.join(Rails.root, 'db', 'seeds', 'amendment_reasons.rb')
load File.join(Rails.root, 'db', 'seeds', 'titles.rb')
load File.join(Rails.root, 'db', 'seeds', 'block_reasons.rb')
load File.join(Rails.root, 'db', 'seeds', 'change_sp_reasons.rb')
load File.join(Rails.root, 'db', 'seeds', 'call_log_case_types.rb')
load File.join(Rails.root, 'db', 'seeds', 'bypass_fingerprint_reasons.rb')
load File.join(Rails.root, 'db', 'seeds', 'finance_settings.rb')
load File.join(Rails.root, 'db', 'seeds', 'ipay88_types.rb')
load File.join(Rails.root, 'db', 'seeds', 'quarantine_reasons.rb')
load File.join(Rails.root, 'db', 'seeds', 'unsuitable_reasons.rb')
load File.join(Rails.root, 'db', 'seeds', 'xray_providers.rb')
load File.join(Rails.root, 'db', 'seeds', 'template_variables.rb')
load File.join(Rails.root, 'db', 'seeds', 'conditions.rb')
load File.join(Rails.root, 'db', 'seeds', 'report_cronjob_emails.rb')

load File.join(Rails.root, 'db', 'seeds', 'agency_license_categories.rb')
load File.join(Rails.root, 'db', 'seeds', 'approval_assignments.rb')
load File.join(Rails.root, 'db', 'seeds', 'associations.rb')
load File.join(Rails.root, 'db', 'seeds', 'races.rb')
load File.join(Rails.root, 'db', 'seeds', 'fpx_banks.rb')
load File.join(Rails.root, 'db', 'seeds', 'fpx_response_codes.rb')
load File.join(Rails.root, 'db', 'seeds', 'fpx_types.rb')
load File.join(Rails.root, 'db', 'seeds', 'fw_verification_par.rb')
load File.join(Rails.root, 'db', 'seeds', 'swipe_types.rb')
load File.join(Rails.root, 'db', 'seeds', 'xray_license_purposes.rb')

return if Rails.env.production? || ENV["prod"]

@sample_count = 10

# states seed is in migration file because sequence migration need states data

load File.join(Rails.root, 'db', 'seeds', 'job_types.rb') # job_type.sql

load File.join(Rails.root, 'db', 'seeds', 'banks.rb') # bank.sql

load File.join(Rails.root, 'db', 'seeds', 'zones.rb') # zone.sql

load File.join(Rails.root, 'db', 'seeds', 'monitor_reasons.rb') # monitor_reason.sql

load File.join(Rails.root, 'db', 'seeds', 'retake_reasons.rb') # retake_reason.sql

load File.join(Rails.root, 'db', 'seeds', 'organizations.rb') # organization.sql

load File.join(Rails.root, 'db', 'seeds', 'district_health_offices.rb') # district_health_office.sql

load File.join(Rails.root, 'db', 'seeds', 'users.rb') # done nios user, pending: portal, merts

# load File.join(Rails.root, 'db', 'seeds', 'service_provider_groups.rb') # service_provider_group.sql, currently laboratory only

# load File.join(Rails.root, 'db', 'seeds', 'laboratories.rb') # laboratory.sql

# load File.join(Rails.root, 'db', 'seeds', 'xray_facilities.rb') # xray_facility.sql

# load File.join(Rails.root, 'db', 'seeds', 'radiologists.rb') # radiologist.sql

# load File.join(Rails.root, 'db', 'seeds', 'doctors.rb') # doctor.sql

# load File.join(Rails.root, 'db', 'seeds', 'employers.rb')

# load File.join(Rails.root, 'db', 'seeds', 'foreign_workers.rb')

# load File.join(Rails.root, 'db', 'seeds', 'transactions.rb')

# load File.join(Rails.root, 'db', 'seeds', 'foreign_worker_real_data.rb')

load File.join(Rails.root, 'db', 'seeds', 'bulletins.rb')

User.update(password: '12345678')
puts "all user password updated to 12345678"

PasswordPolicy.update_all({
    require_alphabet: false,
    require_numeric: true,
    require_special_characters: true,
    require_small_and_capital: true,
    minimum_length: 7
})