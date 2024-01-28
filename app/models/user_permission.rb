class UserPermission < ApplicationRecord
  audited
  include CaptureAuthor
  
  belongs_to :user
end
