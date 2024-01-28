class AddIndexToTransactionsFwPati < ActiveRecord::Migration[6.0]
    def change
        add_index :transactions, :fw_pati
    end
end