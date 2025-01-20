# Modello Unico di Dichiarazione Ambientale
class Mud
  attr_reader :organization, :picked_kgs, :remainders_kgs

  # @picked_kgs[cer][supplier] = 100
  # @picked_kgs[cer][supplier2] = 23
  # @remainders_kgs[cer] = 12
  def initialize(organization, year)
    @organization = organization
    @year = year
    # picked_kgs[cer][supplier] = 0.0.
    @picked_kgs = Hash.new { |hash, key| hash[key] = Hash.new { |hash, key| hash[key] = 0.0 } }
    @remainders_kgs = Hash.new { |hash, key| hash[key] = 0.0 }

    # @picked_kgs is the weight from the supplier in pickings in @year
    organization.pickings
      .where("YEAR(pickings.date) = ?", @year)
      .includes(:supplier, picking_documents: :disposal_type).each do |picking|
      supplier = picking.supplier
      picking.picking_documents.each do |picking_document|
        cer_code = picking_document.disposal_type.cer_code
        @picked_kgs[cer_code][supplier] += picking_document.kgs
      end
    end

    # remainders is the weight of disposals non delivered in @year
    # FIXME think about picking.date != disposal.delivered_at
    organization.disposals
      .where("YEAR(disposals.approved_at) = ? AND YEAR(disposals.delivered_at) != ?", @year, @year)
      .includes(disposal_type: :cer_code).each do |disposal|
      cer_code = disposal.disposal_type.cer_code
      @remainders_kgs[cer_code] += disposal.kgs
    end

    # organization.disposals.where("YEAR(disposals.approved_at) = ?", @year).includes(disposal_type: :cer_code).each do |disposal|
    #   cer_code = disposal.disposal_type.cer_code
    #   if disposal.delivered_at && disposal.delivered_at.year == @year
    #     @picked_kgs[cer_code][:disposals] ||= []
    #     @picked_kgs[cer_code][:disposals] << disposal
    #     @picked_kgs[cer_code][:kgs] ||= 0.0
    #     @picked_kgs[cer_code][:kgs] += disposal.kgs
    #   elsif disposal.approved?
    #     @remainders_kgs[cer_code][:disposals] ||= []
    #     @remainders_kgs[cer_code][:disposals] << disposal
    #     @remainders_kgs[cer_code][:kgs] ||= 0.0
    #     @remainders_kgs[cer_code][:kgs] += disposal.kgs
    #   end
    # end
  end

  def all_cers
    (@picked_kgs.keys + @remainders_kgs.keys).sort.uniq
  end
end
