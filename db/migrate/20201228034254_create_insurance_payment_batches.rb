class CreateInsurancePaymentBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_payment_batches do |t|

      t.string :code, index: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :status

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
