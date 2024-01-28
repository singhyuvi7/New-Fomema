class AddXrayRetakesFieldsFromXrayExaminationRetakes < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_retakes, :radiologist_id, :bigint, index: true
    add_column :xray_retakes, :xray_reporter_type, :string
    add_column :xray_retakes, :xray_film_type, :string
    add_column :xray_retakes, :xray_fp_result, :integer
    add_column :xray_retakes, :xray_worker_identity_confirmed, :boolean, default: false
    add_column :xray_retakes, :digital_xray_provider_id, :bigint, index: true
  end
end
