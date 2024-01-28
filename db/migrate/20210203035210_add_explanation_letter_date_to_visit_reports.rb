class AddExplanationLetterDateToVisitReports < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_reports, :explanation_letter_date, 	:datetime
    add_index  :visit_reports, :explanation_letter_date
  end
end
