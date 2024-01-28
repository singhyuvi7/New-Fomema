class AddFileNameInSurveyMonkey < ActiveRecord::Migration[6.0]
	def change
		add_column :survey_monkey_customers, :file_name, :string
	end
end