class PickingDocument < ApplicationRecord
  belongs_to :picking
  belongs_to :disposal_type

  validates :disposal_type_id, uniqueness: { scope: :picking_id, message: 'Documento già inserito per la tipologia di rifuti.' }
  validates :serial_number, uniqueness: {}
  validate :organization_coherence
  validate :unique_in_organizations_and_year

  def organization_coherence
    (self.disposal_type.organization_id == self.picking.organization_id) or self.errors.add(:base, "UL incoerenti")
  end

  def unique_in_organizations_and_year
    organization = self.picking.organization
    year = self.picking.date.year
    pids = organization.pickings.where('YEAR(date) = ?', year).ids
    if PickingDocument.where(register_number: self.register_number).where(picking_id: pids).any?
      self.errors.add(:register_number, "Non univoco nell'anno #{year}")
    end
  end

  def register_number_with_year
    if self.register_number && self.picking.date
      "#{self.register_number} / #{self.picking.date.year}"
    else
      "???"
    end
  end

end
