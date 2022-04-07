class UnCode < ApplicationRecord
  has_many :disposal_types
  has_many :disposals

  validates :name, presence: true

  def to_s
    "UN " + self.id.to_s 
  end
end
