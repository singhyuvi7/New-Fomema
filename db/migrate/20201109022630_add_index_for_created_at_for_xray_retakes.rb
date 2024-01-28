class AddIndexForCreatedAtForXrayRetakes < ActiveRecord::Migration[6.0]
    def change
        add_index :xray_retakes, :created_at
    end
end