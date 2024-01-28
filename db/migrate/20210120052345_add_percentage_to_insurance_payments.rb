class AddPercentageToInsurancePayments < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_payments, :total_gross_premium, :decimal, default: 0
    add_column :insurance_payments, :commission_percentage, :decimal, default: 0, comment: 'In Percentage (%)'
    add_column :insurance_payments, :transaction_fee, :decimal, default: 0, comment: 'In Percentage (%)'

    remove_column :insurance_payments, :sst, :decimal
    remove_column :insurance_payments, :stamp_duty, :decimal

    rename_column :insurance_payments, :premium, :total_premium
  end
end
