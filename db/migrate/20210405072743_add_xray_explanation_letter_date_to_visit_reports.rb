class AddXrayExplanationLetterDateToVisitReports < ActiveRecord::Migration[6.0]
  def change
    rename_column :visit_reports, :explanation_letter_date, :doctor_explanation_letter_date

    add_column :visit_reports, :xray_explanation_letter_date, 	:datetime
    add_index  :visit_reports, :xray_explanation_letter_date
  end
end
