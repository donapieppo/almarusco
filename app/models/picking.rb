class Picking < ApplicationRecord
  belongs_to :organization
  belongs_to :supplier
  has_many :disposals
  has_many :picking_documents

  scope :undelivered, -> { where('pickings.delivered_at IS NULL') }
  scope :uncompleted, -> { where('pickings.completed_at IS NULL') }

  def to_s
    "Ritiro #{self.supplier} del #{self.date}"
  end
  
  def possible_disposals
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
    ! delivered?
  end

  def completed?
    completed_at
  end

  # return treu/false
  def deliver!
    if self.date
      self.disposals.each {|d| d.deliver!}
      self.update(delivered_at: self.date)
    else
      self.errors.add(:base, "È necessario indicare la data della consegna tra i dati del ritiro prima di confermare.")
      return false
    end
  end

  def complete!
    self.disposals.each {|d| d.complete!}
    self.update(completed_at: Date.today)
  end

  def status
    if self.completed?
      'archiviato'
    elsif self.delivered?
      'consegnato'
    else
      'in corso'
    end
  end

  def picking_document_by_disposal_type(dt)
    self.picking_documents.where(disposal_type: dt).first   
  end
end
