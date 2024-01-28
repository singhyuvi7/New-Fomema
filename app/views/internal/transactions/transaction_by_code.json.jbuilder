json.merge! @transaction.attributes
json.foreign_worker do
    json.merge! @transaction.foreign_worker.attributes
end