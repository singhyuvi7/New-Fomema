class AddXqccPoolsReservedBy < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_pools, :reserved_by, :bigint, index: true
  end
end
