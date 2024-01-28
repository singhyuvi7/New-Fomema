class AddUnutilisedToRefunds < ActiveRecord::Migration[6.0]
  def change
    add_column :refunds, :unutilised, :boolean, index: true, default: false
  end
end
