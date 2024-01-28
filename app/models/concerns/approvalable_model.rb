module ApprovalableModel extend ActiveSupport::Concern

  # request.state : enum state: { pending: 0, cancelled: 1, approved: 2, rejected: 3, executed: 4 }

    def approval_item
        Approval::Item.joins("join approval_requests on approval_items.request_id = approval_requests.id and approval_requests.state = 0").where("resource_id = ? and resource_type = ?", self.id, self.class.name).order("approval_items.created_at desc").first
    end

    def approval_request
        # Approval::Request.joins("join approval_items on approval_items.request_id = approval_requests.id").where("resource_id = ? and resource_type = ?", self.id, self.class.name).order("approval_items.id desc").first
        approval_item.try(:request)
    end
end