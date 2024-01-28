module CaptureAuthor
    extend ActiveSupport::Concern

    included do
        belongs_to :creator, class_name: "User", foreign_key: "created_by", optional: true
        belongs_to :updater, class_name: "User", foreign_key: "updated_by", optional: true
        before_save :capture_author
    end

    def capture_author
        return if Current.user.nil?
        self.updated_by = Current.user.id
        self.created_by = Current.user.id if self.id.nil? and self.created_by.nil?
    end
end