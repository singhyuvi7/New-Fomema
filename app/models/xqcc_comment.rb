class XqccComment < ApplicationRecord

  audited
  include CaptureAuthor

  belongs_to :commentable, polymorphic: true
end
