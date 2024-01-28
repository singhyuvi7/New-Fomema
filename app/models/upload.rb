class Upload < ApplicationRecord
  include CaptureAuthor

  belongs_to :uploadable, polymorphic: true, optional: true
  has_many_attached :documents

  def get_category_description(object, code)
    object.each do |key, value|
      if code == key
        return value
      end
    end
  end

end
