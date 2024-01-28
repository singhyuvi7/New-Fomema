class AddSyncDateToIpay88Requests < ActiveRecord::Migration[6.0]
  def change
    add_column :ipay88_requests, :sync_date, :datetime, index: true
  end
end
