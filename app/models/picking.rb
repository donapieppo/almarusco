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
    self.supplier.contract_picking_disposals(self.organization_id).approved.undelivered
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

  def deliver
    if self.date
      self.disposals.update_all(delivered_at: self.date) # cache
      self.update(delivered_at: self.date)
    else
      self.errors.add(:base, "È necessario indicare la data della consegna tra i dati del ritiro prima di confermare.")
      return false
    end
  end

  def complete
    self.disposals.update_all(completed_at: Date.today) # cache
    self.update(completed_at: Date.today)
  end

  def status
    if self.completed_at
      'archiviato'
    elsif self.delivered_at
      'consegnato'
    else
      'in corso'
    end
  end
end
