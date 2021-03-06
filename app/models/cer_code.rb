class CerCode < ApplicationRecord
  has_many :disposal_typs
  has_many :disposals
  has_and_belongs_to_many :suppliers

  validates :name, presence: true

  def to_s
    "CER " + self.name + (self.danger ? "*" : "")
  end
end
