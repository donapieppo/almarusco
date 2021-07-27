class CerCode < ApplicationRecord
  has_many :disposal_typs
  has_many :disposals

  def to_s
    "CER " + self.name + (self.danger ? "*" : "")
  end
end
