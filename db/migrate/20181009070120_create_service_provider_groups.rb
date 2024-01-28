class CreateServiceProviderGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :service_provider_groups do |t|
      t.string :category, index: true
      t.string :code
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :country, optional: true
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :email

      t.decimal :male_rate, default: 0
      t.decimal :female_rate, default: 0
      t.belongs_to :bank, optional: true
      t.string :bank_account_holder_name
      t.string :bank_account_number
      
      t.string :status, index: true
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
