class AddDateAndReferenceNoToRefunds < ActiveRecord::Migration[6.0]
  def change
    add_column :refunds, :payment_date, :datetime, index: true
    add_column :refunds, :reference, :string, index: true
  end
end
