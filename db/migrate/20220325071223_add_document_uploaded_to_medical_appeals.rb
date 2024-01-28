class AddDocumentUploadedToMedicalAppeals < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_appeals, :doctor_document_uploaded, :boolean, default: false
    add_column :medical_appeals, :laboratory_document_uploaded, :boolean, default: false
  end
end