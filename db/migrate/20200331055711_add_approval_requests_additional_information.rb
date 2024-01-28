class AddApprovalRequestsAdditionalInformation < ActiveRecord::Migration[6.0]
  def change
    add_column :approval_requests, :additional_information, :json
  end
end
