class AddSystemConfigurationsCategory < ActiveRecord::Migration[6.0]
    def change
        add_column :system_configurations, :category, :string
    end
end
