class AddViewedToXrayExaminations < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_examinations, :xray_viewed, :boolean, default: false, null: false
  end
end
