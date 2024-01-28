class AdditionalChangesToDbStructure < ActiveRecord::Migration[6.0]
    def change
        add_column :appeal_todos, :is_active, :boolean
        add_index :medical_appeals, :created_at
    end
end