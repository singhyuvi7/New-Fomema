class RemoveXrayReviewColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_reviews, :picked_up_at
    remove_column :xray_reviews, :picked_up_by

    remove_column :xray_reviews, :id_incomplete
    remove_column :xray_reviews, :id_wrong
    remove_column :xray_reviews, :id_not_clear
    remove_column :xray_reviews, :id_not_printed
    remove_column :xray_reviews, :proc_chemical_defect
    remove_column :xray_reviews, :proc_marks_of_film
    remove_column :xray_reviews, :proc_fog
    remove_column :xray_reviews, :proc_screen_defect
    remove_column :xray_reviews, :pos_roi_cut_off
    remove_column :xray_reviews, :pos_roi_not_clearly_visualized
    remove_column :xray_reviews, :pos_collimation
  end
end
