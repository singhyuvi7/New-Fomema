class AddXraySelectedDateToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :xray_selected, :datetime
        add_index :medical_appeals, :xray_selected
    end
end