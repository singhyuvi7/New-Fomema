class CreateSpGroupHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :sp_group_histories do |t|
      t.bigint :service_providable_id
      t.string :service_providable_type
      t.belongs_to :service_provider_group
      t.datetime :join_date
      t.datetime :exit_date

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :sp_group_histories, [:service_providable_id, :service_providable_type], name: "index_sp_group_histories_service_providable"

  end
end
