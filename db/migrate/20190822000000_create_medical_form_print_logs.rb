class CreateMedicalFormPrintLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :medical_form_print_logs do |t|
      t.belongs_to :transaction

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
