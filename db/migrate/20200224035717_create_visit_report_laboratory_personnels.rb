class CreateVisitReportLaboratoryPersonnels < ActiveRecord::Migration[6.0]
  def change
    create_table :visit_report_laboratory_personnels do |t|
      t.belongs_to :visit_report
      t.string :name
      t.string :designation

      t.timestamps
    end
  end
end
