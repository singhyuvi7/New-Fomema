# change sp reason
{
    '001' => "Clinic close",
    '002' => "Reallocation of worker",
    '003' => "Wrongly choose clinic",
    '004' => "Late appointment by clinic",
    '005' => "Clinic suspended",
    'OTHER' => "Others",
}.each do |code, desc|
    c = ChangeSpReason.where(code: code).first_or_create
    c.update(description: desc)
end
puts("change sp reason seeded")