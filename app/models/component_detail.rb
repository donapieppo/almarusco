class ComponentDetail < ApplicationRecord
  belongs_to :disposal_description
  belongs_to :un_code, optional: true
  has_and_belongs_to_many :hazards
  has_and_belongs_to_many :hp_codes
  has_and_belongs_to_many :adrs

  def to_s
    "#{percentage}% #{name}"
  end

  def hazards_to_s
    hazards.map(&:code).join(" - ")
  end
end
