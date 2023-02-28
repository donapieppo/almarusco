class CerCode < ApplicationRecord
  has_many :disposal_types
  has_many :disposals
  has_many :contracts
  has_many :suppliers, through: :contracts

  validates :name, presence: true, uniqueness: true

  def to_s
    "CER " + self.name + (self.danger ? "*" : "")
  end
end
