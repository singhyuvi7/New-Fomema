class Bulletin < ApplicationRecord
    audited
    include CaptureAuthor

    has_many :bulletin_audiences
    has_many :bulletin_user_view_logs
    has_many :uploads, as: :uploadable

    validates :publish_from, :publish_to, presence: true
    validate :check_to
    
    def self.search_title(title)
        return all if title.blank?
        title = title.strip
        where('bulletins.title ILIKE ?', "%#{title}%")
    end

    def self.search_modification_date(modification_date)
        return all if modification_date.blank?
        where(updated_at: modification_date.to_date.beginning_of_day...modification_date.to_date.end_of_day )
    end

    def self.search_publish_date_from_start_range(start_date)
        return all if start_date.blank?
        where('publish_from >= ?', start_date)
    end

    def self.search_publish_date_from_end_range(end_date)
        return all if end_date.blank?
        where('publish_from < ?', Time.parse(end_date) + 1.day)
    end

    def self.search_publish_date_to_start_range(start_date)
        return all if start_date.blank?
        where('publish_to >= ?', start_date)
    end

    def self.search_publish_date_to_end_range(end_date)
        return all if end_date.blank?
        where('publish_to < ?', Time.parse(end_date) + 1.day)
    end

    def self.search_require_acknowledge(require_acknowledge)
        return all if require_acknowledge.blank?
        where(require_acknowledge: require_acknowledge)
    end

    def self.search_is_pop_up(is_pop_up)
        return all if is_pop_up.blank?
        where(is_pop_up: is_pop_up)
    end

    def check_to
        if self.publish_to < self.publish_from
            errors.add(:publish_to, "date cannot be earlier than publish from date")
        end
    end

    scope :filter_date_and_audiences , -> (user_type, user_id) {
        now = DateTime.now.to_formatted_s(:db)
        where('publish_from <= ? and (publish_to is null or publish_to >= ?)',now, now)
        .where("exists (select 1 from bulletin_audiences where bulletin_audiences.bulletin_id = bulletins.id and bulletin_audiences.bulletin_audienceable_type = ? and (bulletin_audiences.bulletin_audienceable_id is null or bulletin_audiences.bulletin_audienceable_id = ?))", user_type, user_id)
    }
end
