class AddRadiologistSavedAtToXrayExaminations < ActiveRecord::Migration[6.0]
	def change
	    add_column :xray_examinations, :radiologist_saved_at, :datetime
   		add_index :xray_examinations, :radiologist_saved_at
	end
end