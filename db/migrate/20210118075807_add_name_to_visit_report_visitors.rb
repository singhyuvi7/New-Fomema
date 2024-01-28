class AddNameToVisitReportVisitors < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_visitors, :name, :string
  end
end
