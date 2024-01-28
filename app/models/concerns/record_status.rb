# frozen_string_literal: true

# Status module for service provider
module RecordStatus
  extend ActiveSupport::Concern

  STATUS_LIST = {
    active: 'ACTIVE',
    inactive: 'INACTIVE',
    temporary_inactive: 'TEMPORARY_INACTIVE'
  }.freeze

  included do
    scope :with_status, ->(status) { where(status: status) if status.present? }
    scope :suspended, -> { where(status: %w[INACTIVE TEMPORARY_INACTIVE]) }
    scope :suspended_date_between, lambda { |start_date, end_date|
      ids = StatusSchedule.where(status_scheduleable_type: 'Doctor', status: %w[INACTIVE TEMPORARY_INACTIVE], from: start_date..end_date).pluck(:status_scheduleable_id)

      where(id: ids.uniq)
    }
    scope :active, -> { where(status: 'ACTIVE') }
  end
end
