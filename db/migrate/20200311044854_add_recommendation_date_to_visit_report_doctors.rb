class AddRecommendationDateToVisitReportDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_doctors, :recommendation_date, :date
  end
end
