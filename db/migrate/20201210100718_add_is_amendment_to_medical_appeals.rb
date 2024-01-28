class AddIsAmendmentToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :is_amendment, :boolean, default: false
        add_index :medical_appeals, :is_amendment
    end
end