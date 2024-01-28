# retake reasons
[
    {id: 1, name: "Exposure Factor"},
    {id: 2, name: "Lung field cut off"},
    {id: 3, name: "ID Inaccuracy"},
    {id: 4, name: "Superimposed"},
    {id: 5, name: "Doubled Exposed"},
    {id: 6, name: "Artifacts"},
    {id: 7, name: "Error"},
    {id: 8, name: "Others"},
].each do |data|
    r = RetakeReason.where(id: data[:id]).first_or_create
    r.update(data)
end

max_id = RetakeReason.maximum(:id)
sql = "alter sequence if exists retake_reasons_id_seq start with #{max_id + 1}"
ActiveRecord::Base.connection.execute(sql)

puts("retake reason seeded")