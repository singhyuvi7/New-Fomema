class IndexTransactionsIsImmBlocked < ActiveRecord::Migration[6.0]
    def change
        add_index :transactions, :is_imm_blocked
    end
end
