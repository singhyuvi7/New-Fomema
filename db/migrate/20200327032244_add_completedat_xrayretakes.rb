class AddCompletedatXrayretakes < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_retakes, :approved_at, :datetime, index: true
    add_column :xray_retakes, :completed_at, :datetime, index: true
  end
end
