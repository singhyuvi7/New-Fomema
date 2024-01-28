class AddRecommendationDateToVisitReportXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_xray_facilities, :recommendation_date, :date
  end
end
