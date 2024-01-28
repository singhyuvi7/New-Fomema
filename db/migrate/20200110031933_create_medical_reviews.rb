class CreateMedicalReviews < ActiveRecord::Migration[5.2]
	def change
		create_table :medical_reviews do |t|
			t.belongs_to :transaction
			t.bigint 	:medical_mle1_id, index: true
			t.string 	:medical_mle1_decision, index: true
			t.text 		:medical_mle1_comment
			t.datetime 	:medical_mle1_decision_at
			t.bigint 	:medical_mle2_id, index: true
			t.string 	:medical_mle2_decision, index: true
			t.text 		:medical_mle2_comment
			t.datetime 	:medical_mle2_decision_at
			t.timestamps
		end
	end
end