class AddUnsuitableSlipDownloadToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :unsuitable_slip_download, :boolean, default: false
        add_index :transactions, :unsuitable_slip_download
    end
end