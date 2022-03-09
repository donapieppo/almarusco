class Picking < ApplicationRecord
  belongs_to :organization
  belongs_to :supplier
  has_many :disposals
  has_many :picking_documents

  scope :undelivered, -> { where('pickings.delivered_at IS NULL') }

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

    self.disposals.includes(:disposal_type).each do |disposal|
      # p disposal
      res[disposal.disposal_type]['volumes'] ||= {}
      res[disposal.disposal_type]['volumes'][disposal.volume.to_s] = res[disposal.disposal_type]['volumes'][disposal.volume.to_s].to_i + 1
      res[disposal.disposal_type]['kgs'] = res[disposal.disposal_type]['kgs'].to_i + disposal.kgs.to_i
      # p res
    end

    res
  end

  def delivered?
    delivered_at
  end

  def undelivered?
    ! delivered?
  end

  def deliver
    self.disposals.update_all(delivered_at: Date.today)
    self.update(delivered_at: Date.today)
  end

  def confirmed?
    confirmed_at
  end
end
