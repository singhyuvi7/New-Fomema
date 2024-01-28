class AddStatusCommentToServiceProvider < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :status_comment, :text
    add_column :xray_facilities, :status_comment, :text
    add_column :laboratories, :status_comment, :text
    add_column :radiologists, :status_comment, :text

    add_column :status_schedules, :previous_comment, :text
  end
end
