class AddUsersDesignation < ActiveRecord::Migration[6.0]
    def change
        add_column :users, :designation, :string
    end
end
