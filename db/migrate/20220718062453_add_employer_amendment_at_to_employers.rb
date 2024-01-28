class AddEmployerAmendmentAtToEmployers < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :employer_amended_at, :datetime
  end
end
