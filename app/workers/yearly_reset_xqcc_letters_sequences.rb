class YearlyResetXqccLettersSequences
    include Sidekiq::Worker

    def perform(*args)
        # Resets letter sequence to 1 at the start of the year.
        ActiveRecord::Base.connection.execute("select setval('xqcc_wrong_transmission_letter_seq', 1, false)")
        ActiveRecord::Base.connection.execute("select setval('xqcc_misread_letter_seq', 1, false)")
        ActiveRecord::Base.connection.execute("select setval('xqcc_active_tb_letter_seq', 1, false)")
        ActiveRecord::Base.connection.execute("select setval('xqcc_audit_radiographer_letter_seq', 1, false)")
        ActiveRecord::Base.connection.execute("select setval('xqcc_non_compliance_letter_seq', 1, false)")
        ActiveRecord::Base.connection.execute("select setval('xqcc_identical_letter_seq', 1, false)")
    end
end