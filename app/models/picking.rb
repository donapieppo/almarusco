class Picking < ApplicationRecord
  belongs_to :organization
  belongs_to :supplier
  has_many :disposals
  has_many :picking_documents

  scope :undelivered, -> { where("pickings.delivered_at IS NULL") }
  scope :uncompleted, -> { where("pickings.completed_at IS NULL") }

  def to_s
    "Ritiro #{self.supplier} del #{self.date}"
  end

  def possible_disposals
    # for not danger disposal il already legalized whena accepted
    # self.supplier.contract_picking_disposals(self.organization_id).where("legalized_at is not null or cer_codes.danger = 0").undelivered
    self.supplier.contract_picking_disposals(self.organization_id).legalized.undelivered
  end

  def fill_with_default_disposals
    self.disposals = self.possible_disposals
    self.save
  end

  def delivered?
    delivered_at
  end

  def undelivered?
    !delivered?
  end

  def completed?
    completed_at
  end

  # return treu/false
  def deliver!
    if self.date
      self.disposals.each { |d| d.deliver! }
      self.update(delivered_at: self.date)
    else
      self.errors.add(:base, "È necessario indicare la data della consegna tra i dati del ritiro prima di confermare.")
      return false
    end
  end

  def complete!
    self.disposals.each { |d| d.complete! }
    self.update(completed_at: Date.today)
  end

  def status
    if self.completed?
      "archiviato"
    elsif self.delivered?
      "consegnato"
    else
      "in corso"
    end
  end

  def picking_document_by_disposal_type(dt)
    self.picking_documents.where(disposal_type: dt).first
  end

  def date_to_s
    self.date ? I18n.l(date) : "Data non definita"
  end

  def self.other_requests
    [
      [:taniche_10, "TANICHE 10 L."],
      [:taniche_20, "TANICHE 20 L."],
      [:fusti_60, "FUSTI 60 L."],
      [:cravatta, "TANICHE COLLO A CRAVATTA 60 L."],
      [:etichette_r, "ETICHETTE R"],
      [:pittogramma_3, "PITTOGRAMMA \"3\""],
      [:pittogramma_6, "PITTOGRAMMA \"6\""],
      [:pittogramma_9, "PITTOGRAMMA \"9\""],
      [:pittogramma_p_a, "PITTOGRAMMA \"pesce/albero\""]
    ]
  end
end
