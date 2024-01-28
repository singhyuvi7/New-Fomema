class AddBypassToXrayRetakes < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_retakes, :xray_fp_result_date, :datetime, index: true
    add_column :xray_retakes, :xray_fp, :boolean
    add_column :xray_retakes, :xray_bypass_fingerprint_date, :datetime, index: true
    add_column :xray_retakes, :xray_bypass_fingerprint_reason_id, :bigint, index: true
  end
end
