unsuitable_reasons = [
    {
        id: 1,
        english: "The worker's chest x-ray has abnormal findings.",
        bahasa: "Pemeriksaan x-ray dada ke atas pekerja ini mendapati penemuan tidak normal.",
        priority: 1
    },
    {
        id: 2,
        english: "The worker has failed the blood screening test for communicable diseases.",
        bahasa:"Pekerja ini gagal ujian saringan darah untuk penyakit berjangkit.",
        priority: 2
    },
    {
        id: 3,
        english: "The worker has failed the urine screening test for drugs.",
        bahasa: "Pekerja ini gagal ujian saringan urin untuk dadah.",
        priority: 3
    },
    {
        id: 4,
        english: "The worker has failed the urine screening test for pregnancy.",
        bahasa:  "Pekerja ini gagal ujian saringan urin untuk kehamilan.",
        priority: 4
    },
    {
        id: 5,
        english: "The worker has failed the screening test for urine.",
        bahasa: "Pekerja ini gagal ujian saringan urin.",
        priority: 5
    },
    {
        id: 6,
        english: "The worker has abnormal physical findings.",
        bahasa: "Pemeriksaan fizikal ke atas pekerja ini mendapati penemuan tidak normal.",
        priority: 6
    }
]

unsuitable_reasons.each do |reason|
    UnsuitableReason.find_or_create_by(id: reason[:id], reason_en: reason[:english], reason_bm: reason[:bahasa], priority: reason[:priority])
end

puts("Unsuitable Reasons seeded")