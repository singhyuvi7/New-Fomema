class CreateReportCronjobEmails < ActiveRecord::Migration[6.0]
    def change
        create_table :report_cronjob_emails do |t|
            t.integer   :report_cronjob_id
            t.string    :email
            t.string    :recipient_type # main or cc. Must have at least 1 main recipient.
            t.datetime  :deleted_at
            t.timestamps
        end

        add_index :report_cronjob_emails, :report_cronjob_id
        add_index :report_cronjob_emails, :email
        add_index :report_cronjob_emails, :recipient_type
        add_index :report_cronjob_emails, :deleted_at
    end
end