class AddHaveBiodataToForeignWorkers < ActiveRecord::Migration[6.0]
  def change
    add_column :foreign_workers, :have_biodata, :boolean, default: false
  end
end
