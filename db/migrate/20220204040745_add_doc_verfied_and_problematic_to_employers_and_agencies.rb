class AddDocVerfiedAndProblematicToEmployersAndAgencies < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :problematic, :boolean, default: false
    add_index :employers, :problematic
    add_column :agencies, :problematic, :boolean, default: false
    add_index :agencies, :problematic
    add_column :employers, :document_verified, :boolean, default: false
    add_index :employers, :document_verified
    add_column :agencies, :document_verified, :boolean, default: false
    add_index :agencies, :document_verified
  end
end
