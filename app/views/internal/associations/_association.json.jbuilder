json.extract! association, :id, :code, :name, :created_at, :updated_at
json.url internal_association_url(association, format: :json)
