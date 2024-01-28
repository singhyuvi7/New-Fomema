class AddWebServiceIndicatorToLaboratoryExaminations < ActiveRecord::Migration[6.0]
	def change
		add_column :laboratory_examinations, :web_service_indicator, :boolean, default: false
		add_index :laboratory_examinations, :web_service_indicator
	end
end
