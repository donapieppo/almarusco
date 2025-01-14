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

  # necessary form simple_form
  def common
    !organization_id
  end

  def common?
    common
  end
end
