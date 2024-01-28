class SpGroupHistory < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :service_providable, polymorphic: true
    belongs_to :service_provider_group, optional: true
end
