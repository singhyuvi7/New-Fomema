# district health offices
ampangTown = Town.find_by(code: 'E001')
bukitRangTown = Town.find_by(code: '4001')
DistrictHealthOffice.create!({code: "DHO001", name: "BUKIT RANG DISTRICT HEALTH OFFICE", email: "fonghy+dho001@bookdoc.com", address1: "BUKIT RANG NO 1", pic_name: "BUKIT RANG DHO PIC", pic_phone: "+0927374047", town_id: bukitRangTown.id})
DistrictHealthOffice.create!({code: "DHO002", name: "AMPANG DISTRICT HEALTH OFFICE", email: "fonghy+dho002@bookdoc.com", address1: "AMPANG NO 1", pic_name: "AMPANG DHO PIC", pic_phone: "+60338264937", town_id: ampangTown.id})
puts("district health offices seeded")
@district_health_offices = DistrictHealthOffice.all