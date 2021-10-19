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
end
