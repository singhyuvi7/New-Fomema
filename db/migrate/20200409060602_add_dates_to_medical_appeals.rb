class AddDatesToMedicalAppeals < ActiveRecord::Migration[6.0]
	def change
    	add_column :medical_appeals, :registration_date, 	:datetime
    	add_column :medical_appeals, :officer_assigned_at, 	:datetime
    	add_column :medical_appeals, :mle1_decision_at, 	:datetime
    	add_column :medical_appeals, :mle2_decision_at, 	:datetime
    	add_index  :medical_appeals, :registration_date
    	add_index  :medical_appeals, :officer_assigned_at
    	add_index  :medical_appeals, :mle1_decision_at
    	add_index  :medical_appeals, :mle2_decision_at
	end
end