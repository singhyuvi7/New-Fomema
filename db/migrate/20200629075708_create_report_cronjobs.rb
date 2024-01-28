class CreateReportCronjobs < ActiveRecord::Migration[6.0]
    def change
        create_table :report_cronjobs do |t|
            t.string    :report_name
            t.datetime  :deleted_at # use act_as_paranoid
            t.timestamps
        end

        add_index :report_cronjobs, :report_name
        add_index :report_cronjobs, :deleted_at
    end
end

# Create permissions too.