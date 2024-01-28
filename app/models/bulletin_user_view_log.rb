class BulletinUserViewLog < ApplicationRecord
    belongs_to :bulletin
    belongs_to :user
end
