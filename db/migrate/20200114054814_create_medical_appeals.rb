class CreateMedicalAppeals < ActiveRecord::Migration[5.2]
	def change
		create_table :medical_appeals do |t|
			t.string :code, index: {unique: true}
			t.belongs_to 	:transaction
			t.string 		:registered_by_type
			t.integer 		:registered_by_id
			t.integer 		:medical_mle1_id, 	index: true
			t.integer 		:medical_mle2_id, 	index: true
			t.integer 		:doctor_id, 		index: true
			t.integer 		:laboratory_id, 	index: true
			t.integer 		:xray_facility_id, 	index: true
			t.text 			:doctor_reason
			t.text 			:appeal_reason
			t.string 		:status, 			index: true
			t.string 		:result, 			index: true
			# t.string 		:approval_decision, index: true
			# t.text 		:appeal_comments
			t.text 			:mle1_appeal_remarks
			t.text 			:mle2_appeal_remarks
			t.timestamps
		end
	end
end