class AddForeignWorkersStatus < ActiveRecord::Migration[6.0]
    def change
        add_column :foreign_workers, :status, :string, default: "ACTIVE", index: true
    end
end
