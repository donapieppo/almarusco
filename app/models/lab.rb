class Lab < ApplicationRecord
  belongs_to :organization
  has_many :disposals

  def to_s
    self.name
  end
end

