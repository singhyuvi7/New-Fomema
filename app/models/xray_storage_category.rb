class XrayStorageCategory < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :xray_storage
end
