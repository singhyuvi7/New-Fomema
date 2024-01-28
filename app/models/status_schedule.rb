class StatusSchedule < ApplicationRecord
    STATUS_SCHEDULEABLE_TYPES = {
        "Doctor" => "Doctor",
        "Laboratory" => "Laboratory",
        "XrayFacility" => "X-Ray Facility",
        "Radiologist" => "Radiologist"
    }

    ACTIVE_STATUSES = ['ACTIVE']
    INACTIVE_STATUSES = ['INACTIVE', 'TEMPORARY_INACTIVE']

    audited
    include CaptureAuthor

    belongs_to :status_scheduleable, polymorphic: true, optional: true

    validates :from, :status, presence: true
    validate :check_from
    validate :check_to
    validate :check_status_scheduleable

    scope :suspended, -> { where(status: %w[INACTIVE TEMPORARY_INACTIVE]) }

    def self.search_status_scheduleable_type(status_scheduleable_type)
        return all if status_scheduleable_type.blank?
        status_scheduleable_type = status_scheduleable_type.strip
        where("status_schedules.status_scheduleable_type = ?", "#{status_scheduleable_type}")
    end

    def self.search_from(from)
        return all if from.blank?
        where('status_schedules.from >= ?', from)
    end

    def self.search_to(to)
        return all if to.blank?
        where('status_schedules.to < ?', Time.parse(to) + 1.day)
    end

    def self.search_created_by(created_by)
        return all if created_by.blank?
        where('status_schedules.created_by = ?', created_by)
    end

    def self.search_status(status)
        return all if status.blank?
        where("status_schedules.status = ?", status)
    end

    def check_from
        if self.id.blank?
            found = self.status_scheduleable.status_schedules.where("? between status_schedules.from and status_schedules.to", self.from.strftime("%F")).first
            if found
                errors.add(:base, "Status schedules from #{found.from.strftime("%d/%m/%Y")} to #{found.to.strftime("%d/%m/%Y")} found")
            end
        end
    end

    def check_to
        if !self.to.blank?
            if self.to < self.from
                errors.add(:to, "date cannot be earlier than from date")
            end

            sql = "? between status_schedules.from and status_schedules.to"
            if !self.id.blank?
                sql = "#{sql} and id != #{self.id}"
            end
            found = self.status_scheduleable.status_schedules.where(sql, self.to.strftime("%F")).first
            if found
                errors.add(:base, "Status schedules from #{found.from.strftime("%d/%m/%Y")} to #{found.to.strftime("%d/%m/%Y")} found")
            end
            if to_changed? and self.to <= Date.today
                errors.add(:to, "date cannot be before #{Date.tomorrow.strftime("%d/%m/%Y")}")
            end
        end
    end

    def check_status_scheduleable
        if self.status_scheduleable_type.blank? or self.status_scheduleable_id.blank?
            errors.add(:base, "Service provider can't be blank")
        end
    end

    def status_display
        return 'Lifted' if ACTIVE_STATUSES.include? status
        return 'Suspended' if INACTIVE_STATUSES.include? status
        ''
    end

    def status_reason_display
        return unless INACTIVE_STATUSES.include? status

        ServiceProviderStatus::STATUS_REASONS.dig(status, status_reason)
    end

    # list status change in service provider suspension history page
    def format_suspension_history_data
        reason_col = comment
        reason_col.prepend("#{status_reason_display}. ") if status_reason.present? # some records don't have status_reason

        [
            created_at.strftime('%-d-%m-%Y'),
            status_display,
            reason_col
        ]
    end
end
