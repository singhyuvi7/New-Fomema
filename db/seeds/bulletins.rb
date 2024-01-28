# bulletins

(1..10).each do |no|
    from = rand(1..30).days.ago
    to = from + rand(1..60).days
    bulletin = Bulletin.create!({
        title: sprintf("Bulletin title %03d", no),
        content: [
            sprintf("<h1>Bulletin title %03d</h1>", no),
            sprintf("<p>Bulletin %03d content</p>", no),
        ].join("\n"),
        publish_from: from,
        publish_to: to,
        require_acknowledge: rand(0..1) == 1
    })
    BulletinAudience::TYPES.each do |key, val|
        bulletin.bulletin_audiences.create({
            bulletin_audienceable_type: key
        })
    end
end

puts "bulletins seeded"