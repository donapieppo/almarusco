class HpCode < ApplicationRecord
  has_and_belongs_to_many :disposal_types
  has_and_belongs_to_many :disposals

  def code
    "HP#{self.id}"
  end

  def to_s
    "#{self.code} (#{self.name})"
  end

  def pictogram
    i = case self.id
    when 1
      "1"
    when 2
      "3"
    when 3
      "2"
    when 4, 5
      "7"
    when 6
      "6"
    when 7, 10, 11, 13
      "8"
    when 8
      "5"
    when 9, 12
      nil
    when 14
      "9"
    end
    i ? "ghs0#{i}" : nil
  end

  def adr_class(liquid: false)
    case self.id
    when 1
      "1"
    when 2
      "5.1"
    when 3
      liquid ? "3" : "4.1"
    when 4, 5, 7, 10, 11, 12, 13 
      nil
    when 6
      "6.1"
    when 8
      "8"
    when 9
      "6.2"
    when 14
      "9"
    end
  end
end
