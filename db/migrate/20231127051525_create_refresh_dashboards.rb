class CreateRefreshDashboards < ActiveRecord::Migration[6.0]
    def change
      create_table :refresh_dashboards do |t|
        t.integer :geographical
        t.integer :fw_information
        t.integer :dep_information
        t.integer :service_provider
        t.integer :customer_satisfaction
        t.string :created_by
        t.string :modified_by
  
        t.timestamps
      end
    end
  end
  