class AddSyncDateToRefunds < ActiveRecord::Migration[6.0]
  def change
    add_column :refunds, :sync_date, :datetime, index: true
  end
end
