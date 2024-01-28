class SpgrSp < ApplicationRecord
  audited
  include CaptureAuthor
  belongs_to :spable, polymorphic: true
end
