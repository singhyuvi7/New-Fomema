class AddIsMohToMedicalAppeals < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_appeals, :is_moh, :boolean, default: false
    add_column :medical_appeals, :employer_document_uploaded, :boolean, default: false
    add_index :medical_appeals, :is_moh
  end
end