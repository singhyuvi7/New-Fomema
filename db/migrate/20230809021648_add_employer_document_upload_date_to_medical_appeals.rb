class AddEmployerDocumentUploadDateToMedicalAppeals < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_appeals, :employer_document_uploaded_date, 	:datetime
  end
end
