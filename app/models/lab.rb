class Lab < ApplicationRecord
  belongs_to :organization
  belongs_to :building, optional: true
  has_many :disposals

  validates :name, presence: true

  def to_s
    if self.building_id
      "#{self.name} - #{self.building.name}"
    else
      self.name
    end
  end
end
