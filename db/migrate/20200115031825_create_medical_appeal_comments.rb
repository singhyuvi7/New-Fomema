class CreateMedicalAppealComments < ActiveRecord::Migration[5.2]
    def change
        create_table :medical_appeal_comments do |t|
            t.belongs_to    :medical_appeal
            t.belongs_to    :user
            t.text          :comment
            t.datetime      :removed_at,        index: true
            t.timestamps
        end
    end
end