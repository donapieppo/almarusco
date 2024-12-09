# https://intranet.unibo.it/SpaziIct/Web3/Pagine/GestioneRifiutiPericolosiProcedura.aspx
class Compliance < ApplicationRecord
  # omologa di ateneo id organization_id=nil
  belongs_to :organization, optional: true
  has_many :disposal_types, dependent: :nullify

  has_one_attached :document

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end

  def common
    !organization_id
  end

  # Compliance.new(common: true) means it belongs (can be used)
  # to all all organizations
  def common=(x)
    if x
      self.organization_id = nil
    end
  end
end
