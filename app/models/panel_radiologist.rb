class PanelRadiologist < ApplicationRecord
  audited
  include CaptureAuthor
  
  belongs_to :xray_facility
  belongs_to :radiologist
end
