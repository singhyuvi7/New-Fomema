# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.string :code
      t.string :username
      t.string :name
      t.string :status, index: true, default: "ACTIVE"
      t.string :activation_token
      t.references :userable, polymorphic: true, index: true
      t.bigint :employer_supplement_id, index: true
      t.bigint :title_id, index: true

      t.timestamps null: false
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.datetime :deleted_at

      #devise-security
      t.datetime :password_changed_at
      t.string  :unique_session_id, limit: 20
      t.boolean :session_limitable_disabled, default: false, index: true
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :code, unique: true
    add_index :users, :username, unique: true
    add_index :users, :password_changed_at
  end
end
