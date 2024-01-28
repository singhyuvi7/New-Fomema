class CreateTcupiReviews < ActiveRecord::Migration[5.2]
	def change
		create_table :tcupi_reviews do |t|
			t.belongs_to 	:transaction
			t.bigint 		:medical_mle1_id, index: true
			t.string 		:review_decision, index: true
			t.text 			:justification
			t.bigint 		:medical_mle2_id, index: true
			t.string 		:approval_decision, index: true
			t.text 			:approval_remark
			t.timestamps
		end
	end
end