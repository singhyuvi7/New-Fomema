json.extract! country, :id, :code, :name, :created_at, :updated_at
json.url internal_country_url(country, format: :json)
