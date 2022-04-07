class Lab < ApplicationRecord
  belongs_to :organization
  has_many :disposals

  validates :name, presence: true

  def to_s
    self.name
  end
end

