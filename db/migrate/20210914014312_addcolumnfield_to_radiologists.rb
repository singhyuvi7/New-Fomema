class AddcolumnfieldToRadiologists < ActiveRecord::Migration[6.0]
  def change
    # add_column :radiologists, :nationality, :string
    add_column :radiologists, :gender, :string
    # add_column :radiologists, :race, :string
  end
end
