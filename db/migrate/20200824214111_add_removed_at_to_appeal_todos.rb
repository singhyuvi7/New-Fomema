class AddRemovedAtToAppealTodos < ActiveRecord::Migration[6.0]
    def change
        add_column :appeal_todos, :removed_at, :datetime
        add_index :appeal_todos, :removed_at
    end
end