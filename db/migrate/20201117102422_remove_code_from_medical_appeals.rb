class RemoveCodeFromMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        remove_column :medical_appeals, :code
    end
end