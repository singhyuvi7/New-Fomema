class AddIsretakeXqcccomments < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_comments, :is_retake, :boolean, default: false, null: false, index: true
  end
end
