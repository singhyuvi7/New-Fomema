class CreateAppealTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :appeal_todos do |t|
      t.string :code, index: true
      t.string :description

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
