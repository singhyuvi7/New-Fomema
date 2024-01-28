class AddPcridToPcrreviews < ActiveRecord::Migration[6.0]

  def change

    add_column :pcr_reviews, :original_pcr_id, :bigint, index: true
    add_column :pcr_reviews, :pcr_id, :bigint, index: true
    add_column :pcr_reviews, :is_reassign, :boolean, index: true
    add_column :pcr_reviews, :reassign_at, :datetime, index: true

    # remove this col to replace with new column above
    remove_column :pcr_reviews, :picked_up_by
    remove_column :pcr_reviews, :picked_up_at

  end

end
