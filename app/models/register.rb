class Register < ApplicationRecord
  belongs_to :organization

  validates :name, presence: true, uniqueness: {scope: :organization_id, message: "Registro con lo stesso nome già presente nella struttura."}

  def to_s
    name
  end
end
