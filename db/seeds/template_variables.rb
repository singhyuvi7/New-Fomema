# template_variables
[
    {code: 'REGISTRATION_SIGNEE_NAME', name: 'Registration Signee Name', description: 'Registration Letter Signatory Name', value: 'DR. HJ. MOHD RIDZAL BIN MOHD ZAINAL'},
    {code: 'REGISTRATION_SIGNEE_POSITION_LINE_1', name: 'Registration Signee Position Line 1', description: 'Registration Letter Signatory Position First Line', value: 'Chief Operating Officer'},
    {code: 'REGISTRATION_SIGNEE_POSITION_LINE_2', name: 'Registration Signee Position Line 2', description: 'Registration Letter Signatory Position Second Line', value: ''},

    {code: 'REGISTRATION_RADIOLOGIST_SIGNEE_NAME', name: 'Registration Signee Name (Radiologist)', description: 'Radiologist Registration Letter Signatory Name', value: 'KELEN LEONG CHOY FUN'},
    {code: 'REGISTRATION_RADIOLOGIST_SIGNEE_POSITION_LINE_1', name: 'Registration Signee Position Line 1  (Radiologist)', description: 'Radiologist Registration Letter Signatory Position First Line', value: 'Chief Executive Officer'},
    {code: 'REGISTRATION_RADIOLOGIST_SIGNEE_POSITION_LINE_2', name: 'Registration Signee Position Line 2  (Radiologist)', description: 'Radiologist Registration Letter Signatory Position Second Line', value: ''},

    {code: 'ALLOCATION_SIGNEE_NAME', name: 'Allocation Signee Name', description: 'Allocation Letter Signatory Name', value: 'MUHAMMAD FAWZUL BIN MUHAMMAD YUSOFF'},
    {code: 'ALLOCATION_SIGNEE_POSITION_LINE_1', name: 'Allocation Signee Position Line 1', description: 'Allocation Letter Signatory Position First Line', value: 'Senior Manager'},
    {code: 'ALLOCATION_SIGNEE_POSITION_LINE_2', name: 'Allocation Signee Position Line 2', description: 'Allocation Letter Signatory Position Second Line', value: 'Management of Service Providers, Customer Service & Corporate Communications'},

    {code: 'PAIRING_SIGNEE_NAME', name: 'Pairing Signee Name', description: 'Pairing Letter Signatory Name', value: 'MUHAMMAD FAWZUL BIN MUHAMMAD YUSOFF'},
    {code: 'PAIRING_SIGNEE_POSITION_LINE_1', name: 'Pairing Signee Position Line 1', description: 'Pairing Letter Signatory Position First Line', value: 'Senior Manager'},
    {code: 'PAIRING_SIGNEE_POSITION_LINE_2', name: 'Pairing Signee Position Line 2', description: 'Pairing Letter Signatory Position Second Line', value: 'Management of Service Providers, Customer Service & Corporate Communications'},

    {code: 'APPROVAL_SIGNEE_NAME', name: 'Approval Signee Name', description: 'Approval Letter Signatory Name (Change Address)', value: 'DR. HJ. MOHD RIDZAL BIN MOHD ZAINAL'},
    {code: 'APPROVAL_SIGNEE_POSITION_LINE_1', name: 'Approval Signee Position Line 1', description: 'Approval Letter Signatory Position First Line (Change Address)', value: 'Chief Operating Officer'},
    {code: 'APPROVAL_SIGNEE_POSITION_LINE_2', name: 'Approval Signee Position Line 2', description: 'Approval Letter Signatory Position Second Line (Change Address)', value: ''},
    
    {code: 'APPROVAL_RADIOLOGIST_SIGNEE_NAME', name: 'Approval Signee Name (Radiologist)', description: 'Radiologist Approval Letter Signatory Name (Change Address)', value: 'KELEN LEONG CHOY FUN'},
    {code: 'APPROVAL_RADIOLOGIST_SIGNEE_POSITION_LINE_1', name: 'Approval Signee Position Line 1 (Radiologist)', description: 'Radiologist Approval Letter Signatory Position First Line (Change Address)', value: 'Chief Executive Officer'},
    {code: 'APPROVAL_RADIOLOGIST_SIGNEE_POSITION_LINE_2', name: 'Approval Signee Position Line 2 (Radiologist)', description: 'Radiologist Approval Letter Signatory Position Second Line (Change Address)', value: ''},

    {code: 'INSPECTORATE_LETTER_SIGNEE_NAME', name: 'Inspectorate Letter Signee Name', description: 'Inspectorate Letter Signee Name', value: 'Dr. Ungku Naim Akhtar bin Ungku Mohsin'},
    {code: 'INSPECTORATE_LETTER_SIGNEE_POSITION', name: 'Inspectorate Letter Signee Position', description: 'Inspectorate Letter Signee Position', value: 'Manager'},
    {code: 'INSPECTORATE_LETTER_SIGNEE_ABBR', name: 'Inspectorate Letter Signee Abbreviation', description: 'Inspectorate Letter Signee Abbreviation', value: 'DUNAUM'},
    
].each do |data|
    TemplateVariable.create!(data)
end
puts("template_variables seeded")
