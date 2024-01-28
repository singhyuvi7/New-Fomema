class TcupiTodo < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    has_many :transaction_tcupi_todos
    has_many :tcupi_reviews, through: :transaction_tcupi_todos

    default_scope { order(is_active: :desc, id: :asc) }

    def self.search_description(description)
        return all if description.blank?
        description = description.strip
        where('tcupi_todos.description ILIKE ?', "%#{description}%")
    end
end
