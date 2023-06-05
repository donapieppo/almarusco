class Container < ApplicationRecord
  has_and_belongs_to_many :disposal_types
  has_many :disposals

  validates :volume, presence: true, numericality: { greater_than: 0 }

  def to_s
    "#{name} #{volume} lt."
  end
end
