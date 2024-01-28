class YearlyResetTcupiLetterSequence
    include Sidekiq::Worker

    def perform(*args)
        # Resets letter sequence to 1 at the start of the year.
        ActiveRecord::Base.connection.execute("select setval('tcupi_letter_seq', 1, false)")
    end
end