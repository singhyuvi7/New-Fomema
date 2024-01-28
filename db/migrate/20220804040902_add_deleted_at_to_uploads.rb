class AddDeletedAtToUploads < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :deleted_at, :datetime
  end
end
