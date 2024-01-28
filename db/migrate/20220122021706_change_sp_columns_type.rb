class ChangeSpColumnsType < ActiveRecord::Migration[6.0]
  def change
    # remove_column :doctors, :nationality, :string
    # remove_column :xray_facilities, :nationality, :string
    # remove_column :radiologists, :nationality, :string
    add_column :doctors, :nationality_id, :bigint
    add_column :xray_facilities, :nationality_id, :bigint
    add_column :radiologists, :nationality_id, :bigint
    
    # remove_column :doctors, :race, :string
    # remove_column :xray_facilities, :race, :string
    # remove_column :radiologists, :race, :string
    add_column :doctors, :race_id, :bigint
    add_column :xray_facilities, :race_id, :bigint
    add_column :radiologists, :race_id, :bigint
  end
end
