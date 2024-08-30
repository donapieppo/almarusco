class Adr < ApplicationRecord
  has_and_belongs_to_many :disposal_types
  has_and_belongs_to_many :component_details
end
