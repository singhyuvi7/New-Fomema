class RenameLaboratoryClassification < ActiveRecord::Migration[6.0]
  def change
    remove_column :laboratories, :classification, :string
    add_column :laboratories, :samm_accredited_since, :date
    add_column :laboratories, :samm_expiry_date, :date
  end
end
