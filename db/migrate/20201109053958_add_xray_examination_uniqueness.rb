class AddXrayExaminationUniqueness < ActiveRecord::Migration[6.0]
    def change
        add_index :xray_examinations, [:sourceable_type, :sourceable_id], unique: true
    end
end