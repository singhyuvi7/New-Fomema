class BiodataResponse < ApplicationRecord
    FINGERPRINT_TYPES = {
        "lt" => "Left Thumb",
        "li" => "Left Index",
        "lm" => "Left Middle",
        "lr" => "Left Ring",
        "ls" => "Left Little",
        "rt" => "Right Thumb",
        "ri" => "Right Index",
        "rm" => "Right Middle",
        "rr" => "Right Ring",
        "rs" => "Right Little"
    }

    belongs_to :foreign_worker
    belongs_to :biodata_request

    scope :have_afis_id, -> {
        where.not(afis_id: [nil, ""])
    }

    scope :no_afis_id, -> {
        where(:status_code => 'GWY0000').where("afis_id IN (?)", ['',nil])
    }

    scope :no_biodata, -> {
        where.not(:status_code => 'GWY0000')
    }
    
end
