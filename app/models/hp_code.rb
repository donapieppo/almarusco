class HpCode < ApplicationRecord
  has_and_belongs_to_many :disposal_types
  has_and_belongs_to_many :disposals

  def code
    "HP#{self.id}"
  end

  def to_s
    "#{self.code} (#{self.name})"
  end
end
