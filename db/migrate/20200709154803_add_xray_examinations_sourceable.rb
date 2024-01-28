class AddXrayExaminationsSourceable < ActiveRecord::Migration[6.0]
  def up
    remove_index :xray_examinations, :transaction_id
    add_column :xray_examinations, :sourceable_type, :string
    rename_column :xray_examinations, :transaction_id, :sourceable_id
    add_index :xray_examinations, [:sourceable_id, :sourceable_type], name: "index_xray_examinations_on_sourceable"
  end

  def down
    remove_index :transactions, name: "index_xray_examinations_on_sourceable"
    rename_column :xray_examinations, :sourceable_id, :transaction_id
    remove_column :xray_examinations, :sourceable_type
    add_index :xray_examinations, :transaction_id
  end
end
