class AppealTodo < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    has_many :medical_appeal_todos, inverse_of: :appeal_todo

    def self.search_description(description)
        return all if description.blank?
        description = description.strip
        where('appeal_todos.description ILIKE ?', "%#{description}%")
    end
end
