json.extract! foreign_worker, :id, :code, :name, :passport_number, :date_of_birth, :gender, :country_id

json.gender_display ForeignWorker::GENDERS[foreign_worker.gender]

json.country_code foreign_worker.country.code
json.country_name foreign_worker.country.name

json.plks_number foreign_worker.plks_number.to_i
json.is_special_renewal foreign_worker.special_renewal? ? 'Y' : 'N'

json.transaction_fee Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}").amount

# json.employer_type do
#   json.name employer.employer_type.name
# end