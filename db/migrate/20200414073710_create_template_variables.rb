class CreateTemplateVariables < ActiveRecord::Migration[6.0]
  def change
    create_table :template_variables do |t|
      t.string :code
      t.string :name
      t.text :description
      t.string :value

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end