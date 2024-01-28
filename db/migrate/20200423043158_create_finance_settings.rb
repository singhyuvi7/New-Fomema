class CreateFinanceSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :finance_settings do |t|
      t.integer :version
      t.string :code
      t.string :value
      t.text :description

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
