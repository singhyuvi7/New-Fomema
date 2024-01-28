#json.extract! @country, :id, :code, :name
#json.states @country.states, partial: 'internal/states/state_less', as: :state
json.partial! 'internal/states/state_less', collection: @country.states, as: :state