class AddDeletedAtFieldsToExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :doctor_examinations, :deleted_at, :datetime
        add_column :laboratory_examinations, :deleted_at, :datetime
        add_column :xray_examinations, :deleted_at, :datetime
        add_column :medical_examinations, :deleted_at, :datetime
        add_index :doctor_examinations, :deleted_at
        add_index :laboratory_examinations, :deleted_at
        add_index :xray_examinations, :deleted_at
        add_index :medical_examinations, :deleted_at
    end
end