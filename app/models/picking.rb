class Picking < ApplicationRecord
  belongs_to :organization
  belongs_to :supplier
  has_many :disposals

  def possible_disposals
    self.supplier.contract_picking_disposals(self.organization_id).approved
  end

  def fill_with_defoult_disposals
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
      res[disposal.disposal_type]['kgs'] = res[disposal.disposal_type]['kgs'].to_i + disposal.kgs
      # p res
    end

    res
  end
end
