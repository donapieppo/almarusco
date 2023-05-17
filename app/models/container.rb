class Container < ApplicationRecord
  has_and_belongs_to_many :disposal_types

  validates :liters, presence: true, numericality: { greater_than: 0 }

  def to_s
    "#{name} #{liters} lt."
  end
end
