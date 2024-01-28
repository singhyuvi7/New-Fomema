class AddUnsuitableSlipDownloadedToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :unsuitable_slip_downloaded, :boolean, default: false
    end
end