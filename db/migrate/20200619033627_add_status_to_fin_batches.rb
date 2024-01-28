class AddStatusToFinBatches < ActiveRecord::Migration[6.0]
  def change
      add_column :fin_batches, :status, :string
  end
end
