class CreateXrayAppealRetakes < ActiveRecord::Migration[6.0]
	def change
		create_table :xray_appeal_retakes do |t|
			t.integer 	:medical_appeal_id
			t.integer 	:xray_examinationable_id
			t.string 	:xray_examinationable_type
			t.string 	:xray_ref_number
			t.string 	:result
			t.string 	:status
			t.text 		:pcr_impression
			t.datetime 	:xray_taken_date
			t.datetime 	:transmitted_at
			t.timestamps
		end

    	add_index :xray_appeal_retakes, :medical_appeal_id
    	add_index :xray_appeal_retakes, :xray_examinationable_id
    	add_index :xray_appeal_retakes, :xray_examinationable_type
    	add_index :xray_appeal_retakes, :xray_ref_number
    	add_index :xray_appeal_retakes, :result
    	add_index :xray_appeal_retakes, :status
    	add_index :xray_appeal_retakes, :xray_taken_date
    	add_index :xray_appeal_retakes, :transmitted_at
	end
end