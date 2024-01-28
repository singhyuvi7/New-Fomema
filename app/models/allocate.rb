class Allocate < ApplicationRecord
    audited
    include CaptureAuthor
    
    belongs_to :doctor
    belongs_to :old_allocatable, polymorphic: true, optional: true
    belongs_to :new_allocatable, polymorphic: true, optional: true
end
