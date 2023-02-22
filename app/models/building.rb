class Building < ApplicationRecord
  belongs_to :organization
  has_many :labs

  validates :name, presence: true, uniqueness: { scope: :organization_id, message: 'Edificio con lo stesso nome già presente.' }

  def to_s
    self.name
  end
end
