class AddSourceableToXqccpools < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_pools, :sourceable_type, :string, index: true
    add_column :xqcc_pools, :sourceable_id, :bigint, index: true
  end
end
