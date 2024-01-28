class MedicalAppealTodo < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :medical_appeal, inverse_of: :medical_appeal_todos, optional: true
    belongs_to :appeal_todo,    -> { with_deleted }, class_name: "AppealTodo", foreign_key: "appeal_todo_id", inverse_of: :medical_appeal_todos, optional: true

    before_create :set_secondary_type

    def self.lab_secondaries
        [2, 6, 10, 11]
    end

    def self.xray_secondaries
        [1]
    end
private
    def set_secondary_type
        self.secondary_type =
            if MedicalAppealTodo.lab_secondaries.include?(appeal_todo_id)
                "Laboratory"
            elsif MedicalAppealTodo.xray_secondaries.include?(appeal_todo_id)
                "Xray"
            end
    end
end