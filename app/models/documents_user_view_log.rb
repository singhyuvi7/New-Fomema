class DocumentsUserViewLog < ApplicationRecord
    belongs_to :upload
    belongs_to :user
end
