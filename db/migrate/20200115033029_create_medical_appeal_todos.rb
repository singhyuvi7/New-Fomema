class CreateMedicalAppealTodos < ActiveRecord::Migration[5.2]
    def change
        create_table :medical_appeal_todos do |t|
            t.belongs_to    :medical_appeal
            t.belongs_to    :appeal_todo
            t.string        :doctor_remarks,    index: true
            t.datetime      :completed_at,      index: true
            t.datetime      :removed_at,        index: true
            t.string        :secondary_type,    index: true
            t.datetime      :secondary_sent_at, index: true
            t.timestamps
        end
    end
end