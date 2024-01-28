class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :code, index: true
      t.string :name
      t.string :long_name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    load File.join(Rails.root, 'db', 'seeds', 'states.rb')
  end
end
