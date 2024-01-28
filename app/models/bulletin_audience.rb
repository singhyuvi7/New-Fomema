class BulletinAudience < ApplicationRecord
    TYPES = {
        "Doctor" => "Doctor", 
        "Laboratory" => "Laboratory", 
        "XrayFacility" => "X-Ray Facility", 
        "Radiologist" => "Radiologist",
        "Employer" => "Employer",
        "Agency" => "Agency",
    }

    belongs_to :bulletin
    belongs_to :bulletin_audienceable, polymorphic: true, optional: true
end
