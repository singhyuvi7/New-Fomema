module SearchGeo
  extend ActiveSupport::Concern

  included do

    belongs_to :country, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true

    def self.search_state(state)
      return all if state.blank?
      where("#{self.table_name}.state_id = ?", state)
    end

    def self.search_postcode(postcode)
      return all if postcode.blank?
      postcode = postcode.strip
      where("#{self.table_name}.postcode = ?", postcode)
    end

    def self.search_town(town)
      return all if town.blank?
      where("#{self.table_name}.town_id = ?", town)
    end

    def self.search_area(area)
      return all if area.blank?
      joins(:town).where("towns.name ilike ?", "%#{ area }%")
    end
  end
end