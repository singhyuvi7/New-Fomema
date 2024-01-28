class CreatePcrPools < ActiveRecord::Migration[6.0]
  def change
    create_table :pcr_pools do |t|
      t.belongs_to :transaction
      t.string :case_type
      t.string :status, index: true
      t.string :source, index: true
      t.references :sourceable, polymorphic: true, index: true
      t.timestamps
      t.datetime :picked_up_at, index: true
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :picked_up_by, index: true
    end
  end
end
