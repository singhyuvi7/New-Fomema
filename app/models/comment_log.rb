class CommentLog < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :commentable, polymorphic: true, optional: true
end
