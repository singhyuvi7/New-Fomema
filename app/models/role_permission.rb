class RolePermission < ApplicationRecord
  audited
  include CaptureAuthor
  
  belongs_to :role
end
