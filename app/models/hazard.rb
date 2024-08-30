class Hazard < ApplicationRecord
  has_and_belongs_to_many :component_details

  def name
    code
  end
end
