json.extract! foreign_worker, :id, :code, :name, :passport_number, :date_of_birth, :gender, :country_id

json.gender_display ForeignWorker::GENDERS[foreign_worker.gender]

json.country_code foreign_worker.country.code
json.country_name foreign_worker.country.name

json.transaction_fee Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}").amount

# json.employer_type do
#   json.name employer.employer_type.name
# end