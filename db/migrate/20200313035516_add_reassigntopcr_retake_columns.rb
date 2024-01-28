class AddReassigntopcrRetakeColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_retakes, :reassign_to_pcr_id, :bigint, index: true
  end
end
