# https://intranet.unibo.it/SpaziIct/Web3/Pagine/GestioneRifiutiPericolosiProcedura.aspx
class Compliance < ApplicationRecord
  belongs_to :organization, optional: true
  has_many :disposal_types

  has_one_attached :document

  validates :name, presence: true, uniqueness: true
  validates :url, uniqueness: true

  def to_s
    name
  end

  def common
    !organization_id
  end

  def common=(x)
    if x
      self.organization_id = nil
    end
  end
end
