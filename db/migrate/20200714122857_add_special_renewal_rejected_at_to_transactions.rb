class AddSpecialRenewalRejectedAtToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :special_renewal_rejected_at, 	:datetime
    add_index  :transactions, :special_renewal_rejected_at
  end
end
