class CreateCommentLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :comment_logs do |t|
      t.string :commentable_type
      t.bigint :commentable_id
      t.text :comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
    add_index :comment_logs, [:commentable_id, :commentable_type]
  end
end
