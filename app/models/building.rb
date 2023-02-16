class Building < ApplicationRecord
  belongs_to :organization
  has_many :labs

  validates :name, presence: true

  def to_s
    self.name
  end
end
