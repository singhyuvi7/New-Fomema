class DocumentUploadedDefaultToNull < ActiveRecord::Migration[6.0]
  def change
    change_column :medical_appeals, :doctor_document_uploaded, :boolean, default: nil
    change_column :medical_appeals, :laboratory_document_uploaded, :boolean, default: nil
  end
end