class Lab < ApplicationRecord
  belongs_to :organization
  belongs_to :building, optional: true
  has_many :disposals

  validates :name, presence: true, uniqueness: {scope: :building_id, message: "Lab con lo stesso nome già presente nello stesso edificio."}

  # TODO
  # validate lab.organization_id == building.organization_id

  def to_s
    if building_id
      "#{name} - #{building.name}"
    else
      name
    end
  end
end
