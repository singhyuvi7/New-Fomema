class AddDiseaseToAmendedNotifiableTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :amended_notifiable_transactions, :disease, :string
  end
end
