class CreateInsurancePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_payments do |t|
      t.belongs_to :insurance_payment_batch
      t.belongs_to :order
      t.decimal :premium
      t.decimal :sst
      t.decimal :stamp_duty
      t.decimal :commission, comment: 'Commission as of creation date'
      t.decimal :ipay_charges
      t.decimal :total_payment_amount
      t.string :status
      t.text :fail_reason
      t.string :document_number, index: true

      ## store commission as well (reason - commission percentage can be change anytime)
      t.timestamps
    end
  end
end
