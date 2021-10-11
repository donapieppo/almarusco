class Picking < ApplicationRecord
  belongs_to :organization
  belongs_to :supplier
  has_many :disposals
end
