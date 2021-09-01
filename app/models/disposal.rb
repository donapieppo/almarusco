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
    disposal_type.hp_codes.map do |hp|
      hp.adr_class(liquid: self.liquid?)
    end.compact
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
