class ChangeColumnTypeForTransactionAmendment < ActiveRecord::Migration[6.0]
	def change
		rename_column :transaction_amendments, :approved_by_id, :approval_by
		rename_column :transaction_amendments, :approved_at, :approval_at
		change_column :transaction_amendments, :transaction_id, :bigint
	end
end