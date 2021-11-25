class Pictogram < ApplicationRecord
  has_and_belongs_to_many :disposal_types

  def image
    "media/images/#{self.filename}"
  end

  def full_filename
    Rails.root.join('app', 'javascript', 'images', self.filename)
  end
end
