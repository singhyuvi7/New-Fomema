class RemoveVisitedFieldsFromMedicalExaminations < ActiveRecord::Migration[6.0]
    def change
        remove_column :medical_examinations, :visited_condition
        remove_column :medical_examinations, :visited_certification
        remove_column :medical_examinations, :visited_follow_up
    end
end