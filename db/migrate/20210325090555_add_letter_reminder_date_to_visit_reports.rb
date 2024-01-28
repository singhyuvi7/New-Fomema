class AddLetterReminderDateToVisitReports < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_reports, :letter_reminder_date, :date
  end
end
