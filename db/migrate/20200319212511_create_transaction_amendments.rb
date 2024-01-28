class CreateTransactionAmendments < ActiveRecord::Migration[6.0]
	def change
		create_table :transaction_amendments do |t|
			t.integer 	:transaction_id
			t.integer 	:user_id
			t.string 	:original_status
			t.string 	:new_status
			t.text 		:amendment_reason
			t.integer 	:approved_by_id
			t.string 	:approval_status
			t.datetime 	:approved_at
			t.timestamps
		end

    	add_index :transaction_amendments, :transaction_id
    	add_index :transaction_amendments, :user_id
    	add_index :transaction_amendments, :original_status
    	add_index :transaction_amendments, :new_status
    	add_index :transaction_amendments, :approved_by_id
    	add_index :transaction_amendments, :approval_status
    	add_index :transaction_amendments, :approved_at
	end
end
