class Disposal < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :disposal_type
  #belongs_to :un_code
  #belongs_to :cer_code
  #has_and_belongs_to_many :hp_codes

  def liquid?
    self.disposal_type.liquid?
  end

  def solid?
    self.disposal_type.solid?
  end

  def self.available_volumes
    { liquid: [10, 20], solid: [40, 60, 120] }
  end

  def adr_classes
    c = []
    hp_codes.each do |hp|
      c << case hp.id
      when 1
        "1"
      when 2
        "5.1"
      when 3
        self.liquid? ? "3" : "4.1"
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
    c
  end

  def approved?
    approved_at
  end

  def approve!
    self.update(approved_at: Time.now)
  end

  def unapprove!
    self.update(approved_at: nil)
  end

  def status
    approved_at ? 'approvato' : 'da approvare'
  end
end
