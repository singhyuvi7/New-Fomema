# service provider groups

["Doctor", "Laboratory", "XrayFacility"].each do |category|
    (1..3).each do |no|
        town = @towns.sample
        data = {
            category: category,
            name: sprintf("#{category.gsub(/\s+/, "").upcase} GROUP %03d", no),
            address1: "LINE 1",
            address2: "LINE 2",
            country_id: @malaysia,
            town: town,
            state: town.state,
            postcode: sprintf("%05d", rand(0..99999)),
            phone: sprintf("0100000%03d", no),
            fax: sprintf("0100001%03d", no),
            email: sprintf("fonghy+#{category.downcase}group%03d@bookdoc.com", no),
            bank: @banks.sample,
            bank_account_holder_name: sprintf("#{category.upcase}GROUP%03dBAHA", no),
            bank_account_number: sprintf("#{category.upcase}GROUP%03dBAN", no),
            status: "ACTIVE"
        }
        ServiceProviderGroup.create!(data)
    end
end
puts("service provider groups seeded")