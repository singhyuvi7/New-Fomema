class RemoveDocumentNumberAtInsurancePayments < ActiveRecord::Migration[6.0]
  def change
    remove_column :insurance_payments, :document_number, :string
    remove_column :insurance_payments, :status, :string
    remove_column :insurance_payments, :fail_reason, :text
  end
end
