class CreateReportCronjobMailSents < ActiveRecord::Migration[6.0]
    def change
        create_table :report_cronjob_mail_sents do |t|
            t.integer   :report_cronjob_id
            t.text      :main_recipients
            t.text      :cc_recipients
            t.timestamps
        end

        add_index :report_cronjob_mail_sents, :report_cronjob_id
    end
end