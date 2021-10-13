class Supplier < ApplicationRecord
  has_many :pickings
  has_and_belongs_to_many :cer_codes

  validates :name, format: { with: /\w/, message: 'Il nome del fornitore non mi sembra corretto.' }
  validates :pi,   format: { with: /\A[0-9a-zA-Z]{11}\z/, message: 'La partita iva deve contenere 11 caratteri.' },
                   uniqueness: { message: 'Esiste già un fornitore con la stessa partita iva', case_sensitive: false }

  def to_s
    self.name
  end

  def contract_disposal_types
    DisposalType.where('cer_code_id in (?)', self.cer_code_ids)
  end

  def contract_picking_disposals(oid)
    oid = oid.id if oid.is_a?(Organization)
    Disposal.where(organization_id: oid).joins(:disposal_type).where('disposal_types.cer_code_id in (?)', self.cer_code_ids)
  end
end
