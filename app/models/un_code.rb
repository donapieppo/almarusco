class UnCode < ApplicationRecord
  has_many :disposal_types
  has_many :disposals

  def to_s
    "UN " + self.id.to_s 
  end
end
