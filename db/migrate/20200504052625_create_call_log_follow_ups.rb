class CreateCallLogFollowUps < ActiveRecord::Migration[6.0]
  def change
    create_table :call_log_follow_ups do |t|
      t.bigint :call_log_id, index: true
      t.text :comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
