class CerCode < ApplicationRecord
  has_many :disposal_types
  has_many :contracts
  has_many :suppliers, through: :contracts

  validates :name, presence: true, uniqueness: true

  def to_s
    "CER " + self.name + (self.danger ? "*" : "")
  end

  def danger?
    self.danger
  end

  def disposals(org)
    Disposal.where(disposal_type_id: self.disposal_types.where(organization_id: org.id).ids)
  end
end
