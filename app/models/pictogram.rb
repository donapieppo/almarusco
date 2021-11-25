class Pictogram < ApplicationRecord
  has_and_belongs_to_many :disposal_types

  def image
    "media/images/#{self.filename}"
  end
end
