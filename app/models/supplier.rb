class Supplier < ApplicationRecord
  has_many :pickings
  # has_and_belongs_to_many :cer_codes
  has_many :contracts
  has_many :cer_codes, through: :contracts

  validates :name, format: {with: /\w/, message: "Il nome del destinatario non mi sembra corretto."}
  validates :pi, format: {with: /\A[0-9a-zA-Z]{11}\z/, message: "La partita iva deve contenere 11 caratteri."},
                 uniqueness: {message: "Esiste già un destinatario con la stessa partita iva", case_sensitive: false}

  def to_s
    self.name
  end

  def contract_disposal_types(oid)
    oid = oid.id if oid.is_a?(Organization)
    DisposalType.where(organization_id: oid).where(cer_code_id: self.cer_code_ids)
  end

  def contract_picking_disposals(oid)
    oid = oid.id if oid.is_a?(Organization)
    Disposal.where(organization_id: oid).joins(disposal_type: :cer_code).where("disposal_types.cer_code_id in (?)", self.cer_code_ids)
  end
end
