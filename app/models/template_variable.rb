class TemplateVariable < ApplicationRecord
    audited
    include CaptureAuthor

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('template_variables.name ILIKE ?', "%#{name}%")
    end
end
