class PickingDocument < ApplicationRecord
  belongs_to :picking
  belongs_to :disposal_type

  validates :disposal_type_id, uniqueness: { scope: :picking_id, message: 'Documento già inserito per la tipologia di rifuti.' }
  validates :serial_number, uniqueness: {}
  validate :organization_coherence
  validate :unique_register_number_in_organizations_and_year

  def to_s
    "#{self.serial_number} - #{self.register_number}"
  end

  def organization_coherence
    (self.disposal_type.organization_id == self.picking.organization_id) or self.errors.add(:base, "UL incoerenti")
  end

  def unique_register_number_in_organizations_and_year
    # not adr (not danger, has no register_number)
    return true unless disposal_type.adr

    organization = self.picking.organization
    year = self.picking.date.year
    pids = organization.pickings.where('YEAR(date) = ?', year).ids
    if PickingDocument.where.not(id: self.id).where(register_number: self.register_number).where(picking_id: pids).any?
      self.errors.add(:register_number, "non univoco nell'anno #{year}")
    end
  end

  def register_number_with_year
    if ! self.register_number 
      "??? (manca numero)"
    elsif ! self.picking.date
      "??? (manca data in ritiro)"
    else
      "#{self.register_number}/#{self.picking.date.year}"
    end
  end
end
