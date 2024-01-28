class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.bigint :parent_id, index: true
      t.string :code, index: true
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :email
      t.string :org_type, index: true
      t.string :bank_code
      t.string :bank_co
      t.string :bank_acctno
      t.string :bank_zone

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    # users.organization_id
    # add_reference :users, :organization, index: true
  end
end
