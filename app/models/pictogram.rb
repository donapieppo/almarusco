class Pictogram < ApplicationRecord
  has_and_belongs_to_many :disposal_types
  has_and_belongs_to_many :disposal_descriptions

  def image
    self.filename
  end

  def full_filename
    Rails.root.join('app', 'assets', 'images', self.filename)
  end
end
