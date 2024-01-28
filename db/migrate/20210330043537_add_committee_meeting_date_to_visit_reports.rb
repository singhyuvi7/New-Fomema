class AddCommitteeMeetingDateToVisitReports < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_reports, :committee_meeting_date, :date
  end
end
