class AddIgnoreExpiryToTransactions < ActiveRecord::Migration[6.0]
	def change
		add_column :transactions, :ignore_expiry, :boolean
		add_index :transactions, :ignore_expiry
	end
end
