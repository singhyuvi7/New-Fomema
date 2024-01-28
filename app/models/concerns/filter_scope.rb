module FilterScope
  extend ActiveSupport::Concern

  included do
    # scopes

    scope :code, -> code { where(code: code.strip) }

    scope :provider_name, -> name { where('name ILIKE ?', "%#{name.strip}%") }

    scope :state_ids, -> state_ids {

      unless state_ids.nil?
        state_id_arr = state_ids.split(",")
        where(state_id: state_id_arr)
      end

    }

    scope :town_ids, -> town_ids {

      unless town_ids.nil?
        town_id_arr = town_ids.split(",")
        where(town_id: town_id_arr)
      end

    }

    scope :keyword, -> keyword {
      keyword = keyword.strip if !keyword.nil?
      where(name: keyword).or(where(code: keyword))
    }

    scope :postcode, -> postcode {where(postcode: postcode)}

    # end of scopes
  end
end