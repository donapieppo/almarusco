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

  # res[disposal_type][:volumes]["20"][1]
  def disposal_types_volumes_and_kgs
    res = Hash.new { |hash, key| hash[key] = {} }

    self.disposals.includes(disposal_type: :cer_code).each do |disposal|
      res[disposal.disposal_type][:cer_name] = disposal.disposal_type.cer_code.name
      res[disposal.disposal_type][:volumes] ||= {}
      res[disposal.disposal_type][:volumes][disposal.volume.to_s] = res[disposal.disposal_type][:volumes][disposal.volume.to_s].to_i + 1
      res[disposal.disposal_type][:kgs] = res[disposal.disposal_type][:kgs].to_i + disposal.kgs.to_i
    end

    res.sort_by { |dt, h| h[:cer_name] }
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
