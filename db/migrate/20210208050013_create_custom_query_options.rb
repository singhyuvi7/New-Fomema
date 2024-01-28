class CreateCustomQueryOptions < ActiveRecord::Migration[6.0]
    def change
        create_table :custom_query_options do |t|
            t.string    :name
            t.string    :query_options
            t.timestamps
        end

        add_index :custom_query_options, :name, unique: true
    end
end