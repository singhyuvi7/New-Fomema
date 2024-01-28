class AddFailReasonToSpFinBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_fin_batches, :fail_reason, :text
  end
end
