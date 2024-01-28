class AddAppealIdToPcr < ActiveRecord::Migration[6.0]
    def change
        add_column :pcr_reviews, :appeal_id, :bigint
        add_index :pcr_reviews, :appeal_id
        add_column :pcr_pools, :appeal_id, :bigint
        add_index :pcr_pools, :appeal_id
        add_column :digital_xray_movements, :appeal_id, :bigint
        add_index :digital_xray_movements, :appeal_id
    end
end
