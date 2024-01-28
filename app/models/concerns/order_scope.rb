module OrderScope
  extend ActiveSupport::Concern

  included do

    scope :latest, -> { order(id: :desc) }

    scope :latest_updated, -> { order(updated_at: :desc) }

  end

end