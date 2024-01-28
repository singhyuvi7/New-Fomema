class ChangePhysicalPulseToInteger < ActiveRecord::Migration[6.0]
	def change
		change_column :doctor_examinations, :physical_pulse, :integer
		change_column :medical_examinations, :physical_pulse, :integer
	end
end