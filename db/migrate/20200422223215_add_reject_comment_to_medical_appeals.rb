class AddRejectCommentToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :reject_comment, :text
        add_column :medical_appeals, :rejected_at, :datetime
        add_column :medical_appeals, :rejected_by_id, :integer
        add_index :medical_appeals, :rejected_at
        add_index :medical_appeals, :rejected_by_id
    end
end