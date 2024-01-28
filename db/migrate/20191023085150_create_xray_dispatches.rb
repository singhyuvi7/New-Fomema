class CreateXrayDispatches < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_dispatches do |t|
      t.string :code, index: {unique: true}
      t.belongs_to :xray_facility
      t.integer :film_count
      t.integer :received_count
      t.date :sent_date
      t.date :received_date

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
