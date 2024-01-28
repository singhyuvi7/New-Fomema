class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :code, index: {unique: true}
      t.string :name
      t.string :status, index: true, default: 'ACTIVE'
      t.string :category, index: true
      t.string :site, index: true
      t.belongs_to :password_policy
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    # users.role_id
    add_reference :users, :role, index: true

    create_table :role_permissions do |t|
      t.belongs_to :role, index: true
      t.string :permission, index: true
    end

    create_table :user_permissions do |t|
      t.belongs_to :user, index: true
      t.string :permission, index: true
    end
  end
end
