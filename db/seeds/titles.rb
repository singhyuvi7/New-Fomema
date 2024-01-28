# titles
["Dato’", "Datin", "Datuk", "Datuk Sri", "Datin Sri ", "Dato’ Seri", "Datin Sri", "Tan Sri", "Puan Sri"].each do |name|
    Title.where(name: name).first_or_create
end
puts("titles seeded")