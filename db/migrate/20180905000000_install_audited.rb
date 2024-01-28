class InstallAudited < ActiveRecord::Migration[5.2]
  def self.up
    # create_table :audits, :force => true do |t|
    create_range_partition :audits, partition_key: ->{ "created_at" } do |t|
      t.column :auditable_id, :integer
      t.column :auditable_type, :string
      t.column :associated_id, :integer
      t.column :associated_type, :string
      t.column :user_id, :integer
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audited_changes, :text
      t.column :version, :integer, :default => 0
      t.column :comment, :string
      t.column :remote_address, :string
      t.column :request_uuid, :string
      t.column :created_at, :datetime
    end

    add_index :audits, [:auditable_type, :auditable_id, :version], :name => 'auditable_index'
    add_index :audits, [:associated_type, :associated_id], :name => 'associated_index'
    add_index :audits, [:user_id, :user_type], :name => 'user_index'
    add_index :audits, :request_uuid
    add_index :audits, :created_at

    execute("create table audits_default partition of audits default")

    # min - march 1998
    (1998..Time.now.year).each do |year|
      date = Date.new(year, 1, 1)
      create_range_partition_of :audits, name: sprintf("audits_y%04d", year), start_range: date.to_formatted_s("%F"), end_range: (date + 1.year).to_formatted_s("%F")
    end
  end

  def self.down
    drop_table :audits, force: :cascade
    drop_table :audits_template, force: :cascade
  end
end
