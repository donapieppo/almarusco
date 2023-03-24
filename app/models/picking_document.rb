class PickingDocument < ApplicationRecord
  belongs_to :picking
  belongs_to :disposal_type
  has_one :legal_download

  validates :disposal_type_id, uniqueness: { scope: :picking_id, message: 'Documento già inserito per la tipologia di rifuti.' }
  validates :serial_number, uniqueness: true 
  validate :organization_coherence

  def to_s
    "#{self.serial_number}"
  end

  def organization_coherence
    (self.disposal_type.organization_id == self.picking.organization_id) or self.errors.add(:base, "UL incoerenti")
  end

  def danger?
    self.disposal_type.danger?
  end

  def legalized?
    self.legal_record_id || !self.danger?
  end

  def legalize!(legal_record)
    self.update(legal_record_id: legal_record.id)
  end

  def disposals
    self.picking.disposals.where(disposal_type: self.disposal_type)
  end

  def legal_uploads
    LegalUpload.where(id: self.disposals.map(&:legal_record_id))
  end

  def disposals_kgs
    disposals.sum(:kgs)
  end
end
