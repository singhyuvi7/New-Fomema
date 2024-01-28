class AddPoolableToPcrreview < ActiveRecord::Migration[6.0]
  def change
    add_column :pcr_reviews, :poolable_type, :string, index: true
    add_column :pcr_reviews, :poolable_id, :bigint, index: true
  end
end
