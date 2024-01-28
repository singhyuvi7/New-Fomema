module CaptureOrganization extend ActiveSupport::Concern
    included do
        belongs_to :organization, optional: true
        before_save :capture_organization

        scope :by_branch, -> { joins(:organization).where(organizations: { org_type: 'BRANCH' }) }

        delegate :code, :name, to: :organization, prefix: true, allow_nil: true
    end

    def capture_organization
        if (self.created_by.nil? and Current.user.nil?) or !self.organization_id.nil?
            return
        end
        self.organization_id = case (self.creator || Current.user).userable_type
        when "Organization"
            self.creator&.userable_id || Current.user&.userable_id
        when "Employer", "Agency"
            Organization.find_by(code: 'PT').id
        else
            nil
        end
    end
end