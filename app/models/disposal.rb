class Disposal < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :producer, class_name: 'User', optional: true
  belongs_to :disposal_type
  belongs_to :lab
  belongs_to :picking, optional: true 

  validates :volume, presence: true, numericality: { greater_than: 0 }
  validates :kgs, presence: true, numericality: { greater_than: 0 }

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
