state = State.find_by(code: "1")
[
    ["1001", "AYER HITAM"],
    ["1002", "BATU PAHAT"],
    ["1003", "ENDAU"],
    ["1004", "GELANG PATAH"],
    ["1005", "JEMENTAH"],
    ["1006", "JOHOR BAHRU"],
    ["1007", "KAHANG"],
    ["1008", "KANGKAR PULAI"],
    ["1009", "KLUANG"],
    ["1010", "KOTA TINGGI"],
    ["1011", "KULAI"],
    ["1012", "LABIS"],
    ["1013", "LAYANG-LAYANG"],
    ["1014", "MASAI"],
    ["1015", "MERSING"],
    ["1016", "MUAR"],
    ["1017", "PASIR GUDANG"],
    ["1018", "PEKAN NANAS"],
    ["1019", "PERMAS JAYA"],
    ["1020", "PLENTONG"],
    ["1021", "PONTIAN"],
    ["1022", "SEGAMAT"],
    ["1023", "SENAI"],
    ["1024", "SIMPANG RENGGAM"],
    ["1025", "SKUDAI"],
    ["1026", "SRI GADING"],
    ["1027", "TANGKAK"],
    ["1028", "ULU TIRAM"],
    ["1029", "YONG PENG"],
    ["1030", "ISKANDAR PUTERI"],
    ["1031", "PENGERANG"],
    ["1032", "BANDAR PENAWAR"],
    ["1033", "CHAAH"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "2")
[
    ["2001", "ALOR SETAR"],
    ["2002", "BALING"],
    ["2003", "BEDONG"],
    ["2004", "GUAR CHEMPEDAK"],
    ["2005", "GURUN"],
    ["2006", "JITRA"],
    ["2007", "K. SARANG SEMUT"],
    ["2008", "KARANGAN"],
    ["2009", "KUALA KEDAH"],
    ["2010", "KUBANG PASU"],
    ["2011", "KULIM"],
    ["2012", "LANGKAWI"],
    ["2013", "LUNAS"],
    ["2014", "PADANG SERAI"],
    ["2015", "POKOK SENA"],
    ["2016", "SIK"],
    ["2017", "SUNGAI PETANI"],
    ["2018", "YAN"],
    ["2019", "PENDANG"],
    ["2020", "CHANGLUN"],
    ["2021", "KODIANG"],
    ["2022", "SANGLANG"],
    ["2023", "KUALA KETIL"],
    ["2024", "KUALA NERANG"],
    ["2025", "KEPALA BATAS"],
    ["2026", "KOTA KUALA MUDA"],
    ["2027", "MERBOK"],
    ["2028", "BANDAR BHARU"],
    ["2029", "SERDANG"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "3")
[
    ["3001", "GUA MUSANG"],
    ["3002", "KOTA BHARU"],
    ["3003", "KUALA KRAI"],
    ["3004", "MACHANG"],
    ["3005", "PASIR MAS"],
    ["3006", "PASIR PUTEH"],
    ["3007", "RANTAU PANJANG"],
    ["3008", "TANAH MERAH"],
    ["3009", "BACHOK"],
    ["3010", "JELI"],
    ["3011", "PENGKALAN KUBOR"],
    ["3012", "TUMPAT"],
    ["3013", "WAKAF BHARU"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "4")
[
    ["4001", "BANGSAR"],
    ["4002", "BATU CAVES"],
    ["4003", "BRICKFIELDS"],
    ["4004", "BUKIT BINTANG"],
    ["4005", "BUKIT DAMANSARA"],
    ["4006", "CHERAS"],
    ["4007", "CHOW KIT"],
    ["4008", "GOMBAK"],
    ["4009", "JLN AMPANG"],
    ["4010", "JLN BUKIT NENAS"],
    ["4011", "JLN HANG LEKIU"],
    ["4012", "JLN IMBI"],
    ["4013", "JLN INAI"],
    ["4014", "JLN IPOH"],
    ["4015", "JLN KENANGA"],
    ["4016", "JLN KLANG LAMA"],
    ["4017", "JLN KUCHAI LAMA"],
    ["4018", "JLN KUCHING"],
    ["4019", "JLN P. RAMLEE"],
    ["4020", "JLN P.RAMLEE"],
    ["4021", "JLN PAHANG"],
    ["4022", "JLN PANTAI BARU"],
    ["4023", "JLN PEKELILING"],
    ["4024", "JLN PINANG"],
    ["4025", "JLN PUDU"],
    ["4026", "JLN PUTRA"],
    ["4027", "JLN RAJA CHULAN"],
    ["4028", "JLN RAJA LAUT"],
    ["4029", "JLN SEMARAK"],
    ["4030", "JLN SILANG"],
    ["4031", "JLN TAR"],
    ["4032", "JLN TRAVERS"],
    ["4033", "JLN TUN RAZAK"],
    ["4034", "KAMPUNG BARU"],
    ["4035", "KEPONG"],
    ["4036", "KERAMAT"],
    ["4037", "KL"],
    ["4039", "LEBUH AMPANG"],
    ["4040", "MAHARAJALELA"],
    ["4041", "MASJID INDIA"],
    ["4042", "PUCHONG"],
    ["4043", "PUTRAJAYA"],
    ["4044", "S. HISHAMUDDIN"],
    ["4045", "SALAK SELATAN"],
    ["4046", "SEGAMBUT"],
    ["4047", "SELAYANG"],
    ["4048", "SENTUL"],
    ["4049", "SERI PETALING"],
    ["4050", "SETAPAK"],
    ["4051", "SRI DAMANSARA"],
    ["4052", "SRI HARTAMAS"],
    ["4053", "SULTAN ISMAIL"],
    ["4054", "SUNGAI BESI"],
    ["4055", "T.T.D.I."],
    ["4056", "TAMAN MELAWATI"],
    ["4057", "TITIWANGSA"],
    ["4058", "WANGSA MAJU"],
    ["4059", "JLN STONOR"],
    ["4060", "JLN CHAN SOW LIN"],
    ["4061", "JLN KIA PENG"],
    ["4062", "BUKIT JALIL"],
    ["4063", "JLN SULTAN SULAIMAN"],
    ["4064", "JLN MELAKA"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "5")
[
    ["5001", "ALOR GAJAH"],
    ["5002", "AYER KEROH"],
    ["5003", "BANDAR MELAKA"],
    ["5004", "BATU BERENDAM"],
    ["5005", "BUKIT BERUANG"],
    ["5006", "CHENG"],
    ["5007", "DURIAN TUNGGAL"],
    ["5008", "JASIN"],
    ["5009", "KLEBANG"],
    ["5010", "KLEBANG BESAR"],
    ["5011", "MASJID TANAH"],
    ["5012", "MELAKA TENGAH"],
    ["5013", "MERLIMAU"],
    ["5014", "PERINGGIT"],
    ["5015", "SELANDAR"],
    ["5016", "TAMPIN"],
    ["5017", "TANJUNG MINYAK"],
    ["5018", "TANJUNG KELING"],
    ["5019", "SUNGAI UDANG"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "6")
[
    ["6001", "BAHAU"],
    ["6002", "GEMAS"],
    ["6003", "GEMENCHEH"],
    ["6004", "JELEBU"],
    ["6005", "JEMPOL"],
    ["6006", "KUALA PILAH"],
    ["6007", "LINGGI"],
    ["6008", "MANTIN"],
    ["6009", "NILAI"],
    ["6010", "PORT DICKSON"],
    ["6011", "RANTAU"],
    ["6012", "REMBAU"],
    ["6013", "SENAWANG"],
    ["6014", "SEREMBAN"],
    ["6015", "SUNGAI GADUT"],
    ["6016", "TAMPIN"],
    ["6017", "BANDAR ENSTEK"],
    ["6018", "ROMPIN"],
    ["6019", "BATU KIKIR"],
    ["6020", "BANDAR SRI SENDAYAN"],
    ["6021", "LABU"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "7")
[
    ["7001", "BDR TUN RAZAK"],
    ["7002", "BENTONG"],
    ["7003", "BERA"],
    ["7004", "CAM HIGHLANDS"],
    ["7005", "JENGKA"],
    ["7006", "JERANTUT"],
    ["7007", "KARAK"],
    ["7008", "KEMAYAN"],
    ["7009", "KUALA LIPIS"],
    ["7010", "KUANTAN"],
    ["7011", "MARAN"],
    ["7012", "MENGKUANG"],
    ["7013", "MENTAKAB"],
    ["7014", "MUADZAM SHAH"],
    ["7015", "PEKAN"],
    ["7016", "RAUB"],
    ["7017", "ROMPIN"],
    ["7018", "TEMERLOH"],
    ["7019", "TRIANG"],
    ["7020", "GENTING HIGHLANDS"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "8")
[
    ["8001", "AYER TAWAR"],
    ["8002", "BAGAN DATOH"],
    ["8003", "BAGAN SERAI"],
    ["8004", "BATU GAJAH"],
    ["8005", "BIDOR"],
    ["8006", "BRUAS"],
    ["8007", "CHEMOR"],
    ["8008", "GOPENG"],
    ["8009", "GRIK"],
    ["8010", "HUTAN MELINTANG"],
    ["8011", "IPOH"],
    ["8012", "KAMPAR"],
    ["8013", "KAMUNTING"],
    ["8014", "KG GAJAH"],
    ["8015", "KUALA KANGSAR"],
    ["8016", "LANGKAP"],
    ["8017", "LUMUT"],
    ["8018", "PANTAI REMIS"],
    ["8019", "PARIT BUNTAR"],
    ["8020", "PULAU PANGKOR"],
    ["8021", "PUSING"],
    ["8022", "SERI ISKANDAR"],
    ["8023", "SIMPANG PULAI"],
    ["8024", "SITIAWAN"],
    ["8025", "SLIM RIVER"],
    ["8026", "SUNGAI SIPUT"],
    ["8027", "SUNGKAI"],
    ["8028", "TAIPING"],
    ["8029", "TANJONG MALIM"],
    ["8030", "TANJONG TUALANG"],
    ["8031", "TAPAH"],
    ["8032", "TELUK INTAN"],
    ["8033", "TG RAMBUTAN"],
    ["8034", "TRONOH"],
    ["8035", "LAHAT"],
    ["8036", "SELAMA"],
    ["8037", "MANJUNG"],
    ["8038", "PARIT"],
    ["8039", "MALIM NAWAR"],
    ["8040", "BOTA"],
    ["8041", "PADANG RENGAS"],
    ["8042", "LARUT MATANG"],
    ["8043", "TROLAK"],
    ["8044", "LENGGONG"],
    ["8045", "TEMOH"],
    ["8046", "TANJUNG PIANDANG"],
    ["8047", "KERIAN"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "9")
[
    ["9001", "ARAU"],
    ["9002", "KANGAR"],
    ["9003", "KUALA PERLIS"],
    ["9004", "PADANG BESAR"],
    ["9005", "SANGLANG"],
    ["9006", "BESERI"],
    ["9007", "SIMPANG EMPAT"],
    ["9008", "KAKI BUKIT"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "A")
[
    ["A001", "AYER ITAM"],
    ["A002", "BALIK PULAU"],
    ["A003", "BATU FERINGGI"],
    ["A004", "BAYAN BARU"],
    ["A005", "BAYAN LEPAS"],
    ["A006", "BUKIT JAMBUL"],
    ["A007", "BUKIT MERTAJAM"],
    ["A008", "BUTTERWORTH"],
    ["A009", "GELUGOR"],
    ["A010", "GEORGETOWN"],
    ["A011", "JELUTONG"],
    ["A012", "KEPALA BATAS"],
    ["A013", "NIBONG TEBAL"],
    ["A014", "PAYA TERUBONG"],
    ["A015", "PERAI"],
    ["A016", "PERMATANG PAUH"],
    ["A017", "SEBERANG JAYA"],
    ["A018", "SIMPANG AMPAT"],
    ["A019", "SUNGAI ARA"],
    ["A020", "SUNGAI BAKAP"],
    ["A021", "SUNGAI NIBONG"],
    ["A022", "TANJUNG BUNGAH"],
    ["A023", "TANJUNG TOKONG"],
    ["A024", "TELUK BAHANG"],
    ["A025", "TELUK KUMBAR"],
    ["A026", "SEBERANG PERAI"],
    ["A027", "SUNGAI JAWI"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "B")
[
    ["B001", "BEAUFORT"],
    ["B002", "BELURAN"],
    ["B003", "KALABAKAN"],
    ["B004", "KENINGAU"],
    ["B005", "KINABATANGAN"],
    ["B006", "KOTA BELUD"],
    ["B007", "KOTA KINABALU"],
    ["B008", "KOTA MARUDU"],
    ["B009", "KUDAT"],
    ["B010", "KUNAK"],
    ["B011", "NOT IN USE (B011-LBN)"],
    ["B012", "LABUK SUGUT"],
    ["B013", "LAHAD DATU"],
    ["B014", "LAHAD DATU(IOI)"],
    ["B015", "PAPAR"],
    ["B016", "PENAMPANG"],
    ["B017", "RANAU"],
    ["B018", "SANDAKAN"],
    ["B019", "SEMPORNA"],
    ["B020", "SIPITANG"],
    ["B021", "SUNGEI SEGAMA"],
    ["B022", "TAWAU"],
    ["B023", "TELUPID"],
    ["B024", "TENOM"],
    ["B025", "TUARAN"],
    ["B026", "NOT IN USE (B026-LBN)"],
    ["B027", "BDR CENDERAWASIH"],
    ["B028", "PANTAI BARAT"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "C")
[
    ["C001", "BAU"],
    ["C002", "BINTULU"],
    ["C003", "KOTA SEMARAHAN"],
    ["C004", "KUCHING"],
    ["C005", "LAWAS"],
    ["C006", "MIRI"],
    ["C007", "SARIKEI"],
    ["C008", "SERIAN"],
    ["C009", "SIBU"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "D")
[
    ["D001", "DUNGUN"],
    ["D002", "JERTEH"],
    ["D003", "K.TERENGGANU"],
    ["D004", "KEMAMAN"],
    ["D005", "KERTEH"],
    ["D006", "KETENGAH JAYA"],
    ["D007", "KUALA BERANG"],
    ["D008", "MARANG"],
    ["D009", "PAKA"],
    ["D010", "SETIU"],
    ["D011", "BESUT"],
    ["D012", "HULU TERENGGANU"],
    ["D013", "KUALA NERUS"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "E")
[
    ["E001", "AMPANG"],
    ["E002", "BALAKONG"],
    ["E003", "BANDAR SUNWAY"],
    ["E004", "BANGI"],
    ["E005", "BATANG KALI"],
    ["E006", "BATU CAVES"],
    ["E007", "BERANANG"],
    ["E008", "BTG BERJUNTAI"],
    ["E009", "CHERAS"],
    ["E010", "DENGKIL"],
    ["E011", "GOMBAK"],
    ["E012", "HULU LANGAT"],
    ["E013", "HULU SELANGOR"],
    ["E014", "JLN KLANG LAMA"],
    ["E015", "KAJANG"],
    ["E016", "KALUMPANG"],
    ["E017", "KEPONG"],
    ["E018", "KLANG"],
    ["E019", "KUALA LANGAT"],
    ["E020", "KUALA SELANGOR"],
    ["E021", "PETALING JAYA"],
    ["E022", "PORT KLANG"],
    ["E023", "PUCHONG"],
    ["E024", "RAWANG"],
    ["E025", "SABAK BERNAM"],
    ["E026", "SEKINCHAN"],
    ["E027", "SELAYANG"],
    ["E028", "SEMENYIH"],
    ["E029", "SEPANG"],
    ["E030", "SERENDAH"],
    ["E031", "SERI KEMBANGAN"],
    ["E032", "SHAH ALAM"],
    ["E033", "SUBANG JAYA"],
    ["E034", "SUNGAI BESAR"],
    ["E035", "SUNGAI BULOH"],
    ["E036", "TAMAN MELAWATI"],
    ["E037", "SERDANG"],
    ["E038", "SERDANG RAYA"],
    ["E039", "SALAK TINGGI"],
    ["E040", "BANTING"],
    ["E041", "KAPAR"],
    ["E042", "CYBERJAYA"],
    ["E043", "PUNCAK ALAM"],
    ["E044", "BESTARI JAYA"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "F")
[
    ["F001", "PUTRA JAYA"],
    ["F002", "PRESINT 1"],
    ["F003", "PRESINT 2"],
    ["F004", "PRESINT 3"],
    ["F005", "PRESINT 4"],
    ["F006", "PRESINT 5"],
    ["F007", "PRESINT 6"],
    ["F008", "PRESINT 7"],
    ["F009", "PRESINT 8"],
    ["F010", "PRESINT 9"],
    ["F011", "PRESINT 10"],
    ["F012", "PRESINT 11"],
    ["F013", "PRESINT 12"],
    ["F014", "PRESINT 13"],
    ["F015", "PRESINT 14"],
    ["F016", "PRESINT 15"],
    ["F017", "PRESINT 16"],
    ["F018", "PRESINT 17"],
    ["F019", "PRESINT 18"],
    ["F020", "PRESINT 19"],
    ["F021", "PRESINT 20"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

state = State.find_by(code: "G")
[
    ["G001", "LABUAN"]
].each do |arr|
    state.towns.create({
        code: arr[0],
        name: arr[1]
    })
end

puts "towns seeded"

@towns = Town.all