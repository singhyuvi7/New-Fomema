class CreateEmployerSupplements < ActiveRecord::Migration[5.2]
  def change
    create_table :employer_supplements do |t|
      t.belongs_to :employer
      t.string :name, index: true
      t.string :pic_name
      t.string :pic_phone
      t.string :email
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.string :postcode
      t.string :phone
      t.string :fax

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
