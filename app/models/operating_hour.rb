class OperatingHour < ApplicationRecord
  audited
  include CaptureAuthor

  belongs_to :operating_hourable, polymorphic: true  
end
