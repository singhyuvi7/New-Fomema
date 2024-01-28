class CreateXqccComments < ActiveRecord::Migration[6.0]
  def change
    create_table :xqcc_comments do |t|
      t.belongs_to :commentable, polymorphic: true, index: true
      t.string :comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
