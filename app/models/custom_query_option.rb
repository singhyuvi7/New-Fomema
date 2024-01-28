class CustomQueryOption < ApplicationRecord
    validates :name, presence: true

    serialize :query_options
end