class AddPcrIdToXrayAppealRetakes < ActiveRecord::Migration[6.0]
	def change
    	add_column :xray_appeal_retakes, :pcr_id, :integer
    	add_column :xray_appeal_retakes, :pcr_picked_up_at, :datetime
    	add_index :xray_appeal_retakes, :pcr_id
    	add_index :xray_appeal_retakes, :pcr_picked_up_at
	end
end
