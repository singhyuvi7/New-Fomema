# This migration comes from approval_engine (originally 20180409000000)
class CreateApprovalTables < ActiveRecord::Migration[5.0]
  def change
    create_table :approval_requests do |t|
      t.integer  :request_user_id, null: false
      t.integer  :respond_user_id
      t.integer  :state,           null: false, limit: 1, default: 0
      t.datetime :requested_at,    null: false
      t.datetime :cancelled_at
      t.datetime :approved_at
      t.datetime :rejected_at
      t.datetime :executed_at
      
      t.boolean :is_draft, default: false
      t.string :category

      t.string :approval_decision
      t.integer  :approval_user_id
      t.datetime :approval_at

      t.string :approval2_decision
      t.integer  :approval2_user_id
      t.datetime :approval2_at

      t.timestamps

      t.index :request_user_id
      t.index :respond_user_id
      t.index :approval_user_id
      t.index :approval2_user_id
      t.index :state
    end

    create_table :approval_items do |t|
      t.integer :request_id,    null: false
      t.integer :resource_id
      t.string  :resource_type, null: false
      t.string  :event,         null: false
      t.text    :params

      t.timestamps

      t.index :request_id
      t.index [:resource_id, :resource_type]
    end

    create_table :approval_comments do |t|
      t.integer :request_id, null: false
      t.integer :user_id,    null: false
      t.text    :content,    null: false

      t.timestamps

      t.index :request_id
      t.index :user_id
    end
  end
end
