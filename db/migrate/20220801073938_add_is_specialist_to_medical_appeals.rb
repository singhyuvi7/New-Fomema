class AddIsSpecialistToMedicalAppeals < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_appeals, :is_specialist, :boolean, default: false
  end
end
