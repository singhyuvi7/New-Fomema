# tcupi todos
["GP's report on correction of vision", "To get the commitment letter from the employer", "Repeat ABO (Rh) grouping and send to two different labs", "Need verification of ID", "Repeat CXR", "To audit CXR by FOMEMA", "Others"].each.with_index(1) do |desc, index|
    tcupi_todo = TcupiTodo.with_deleted.find_or_initialize_by(id: index)
    tcupi_todo.update(description: desc, is_active: true)
end

# Please take note, the index is very important. There are 7 in above code, so index should start from 8.
["Repeat U/FEME", "Renal Profile", "FBS and HBA1C", "Ultrasound", "To get ophthalmologis's report", "To get further assessment report", "Repeat urine drug", "Repeat UPT"].each.with_index(8) do |desc, index|
    tcupi_todo = TcupiTodo.with_deleted.find_or_initialize_by(id: index)
    tcupi_todo.update(description: desc, is_active: false)
end

# On their platform, will need to map accordingly.
# Check transaction_tcupi_todos.sql.
    # 1   Repeat U/FEME
    # 2   Renal Profile
    # 3   FBS and HBA1C
    # 4   Ultrasound
    # 8   To get ophthalmologis's report
    # 9   To get further assessment report
    # 12  Repeat urine drug
    # 13  Repeat UPT
    # 5   GP's report on correction of vision
    # 6   To get the commitment letter from the employer
    # 7   Repeat CXR
    # 10  Repeat ABO (Rh) grouping and send to two different labs
    # 11  Need verification of ID
    # 14  Others
    # 15  To audit CXR*

puts("tcupi todos seeded")

@index = 0

# Appeal To Dos
[
    "Appeal for Digital X-Ray.",
    "To request for HIV Confirmatory test (Western Blot) on primary blood/serum sample.",
    "Declaration form verifying ID of FW.",
    "To submit new evidence (X-Ray film) with report to Medical Department FOMEMA within 7 days.",
    "To get Dermatologist assessment report for Slit Skin Test.",
    "To request for Hbs/AG (ELISA/CMIA) screening test on duplicated sample of original blood/serum sample.",
    "To get Psychiatrist's assessment report.",
    "To get Neurologist assessment report.",
    "To get Oncologist assessment report.",
    "To request for opiates confirmation test (GCMS) on primary urine sample kept by the original lab.",
    "To request for Cannabinoids Confirmation test (GCMS) on primary urine sample kept by the original lab.",
    "To do Hypertension assessment report with BP measurement before and after treatment.",
    "To get Physician assessment report if needed.",
    "Other related systemic examination, especially for signs of target organ damage and fitness for employment.",
    "Employer's commitment letter.",
    "To get Cardiologist's assessment with ECHO report.",
    "To get Respiratory/Chest Physician's assessment report.",
    "To do FBS and HBA1C before and after treatment.",
    "To get Endocrinologist / Physician assessment report if needed.",
    "Surgeon's assessment report.",
    "Physician's assessment report.",
    "Orthopedic Surgeon's assessment report.",
    "To Repeat Urine Albumin.",
    "To get Nephrologist‘s/ Urologist’s assessment report if needed.",
    "To do aided Vision assessment report.",
    "To get Ophthalmologist's assessment report (if necessary)."
].each.with_index(1) do |desc, index|
    appeal_todo = AppealTodo.with_deleted.find_or_initialize_by(id: index)
    appeal_todo.update(description: desc, is_active: true)
end

# Removed Appeal To Dos for migration purposes.
# Please take note, the index is very important. There are 26 in above code, so index should start from 8.
[
    "Request for Chest X-ray Audit to XQCC",
    "No appeal.",
    "Send original slide to Makmal Kesihatan Awam Sg. Buloh through Pantai Fomema.",
    "Serum HCG test on primary blood/serum sample kept by the original lab.",
    "Urologist assessment report.",
    "O&G Specialist's Assessment Report",
    "Physician assessment including Full Blood Picture report.",
    "Repeat U/FEME and Renal Profile.",
    "Thyroid Function Test.",
    "Ultrasound report of the abdomen.",
    "Please contact FOMEMA.",
    "Orthopedic/Surgeon assessment report"
].each.with_index(27) do |desc, index|
    appeal_todo = AppealTodo.with_deleted.find_or_initialize_by(id: index)
    appeal_todo.update(description: desc, is_active: false)
end

# This was removed. Please keep here, will need to maintain the ID sequence for migration scripts.
# Was never used.
to_remove = AppealTodo.find_by(description: "To get Physician assessment report if needed.")
to_remove.update(is_active: false, deleted_at: Time.now) if to_remove.present?

puts("appeal todos seeded")