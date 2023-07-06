class Building < ApplicationRecord
  belongs_to :organization
  has_many :labs

  validates :name, presence: true, uniqueness: {scope: :organization_id, message: "Edificio con lo stesso nome già presente."}

  def to_s
    self.name
  end

  def to_s_long
    "#{self.name} - #{self.address}"
  end

  def to_s_complete
    "#{self.name} - #{self.description} - #{self.address}"
  end
end
