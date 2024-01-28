class CreateMedicalAppealAssignments < ActiveRecord::Migration[6.0]
	def change
		create_table :medical_appeal_assignments do |t|
			t.bigint 	:medical_appeal_id
			t.string 	:user_type
			t.integer 	:user_id
			t.integer 	:whodidit_id
			t.timestamps
		end

		add_index :medical_appeal_assignments, :medical_appeal_id
		add_index :medical_appeal_assignments, :user_type
		add_index :medical_appeal_assignments, :user_id
		add_index :medical_appeal_assignments, :whodidit_id
	end
end