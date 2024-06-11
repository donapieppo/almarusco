# Modello Unico di Dichiarazione Ambientale
class Mud
  attr_reader :organization, :summary, :remainders

  # @summary[cer][:disposals] = [d1, d2...]
  # @summary[cer][:kgs] = 123
  def initialize(organization, year: 2023)
    @organization = organization
    @year = year
    @summary = Hash.new { |hash, key| hash[key] = {} }
    @remainders = Hash.new { |hash, key| hash[key] = {} }

    # @summary is the weight from the supplier in pickings in @year
    organization.pickings
      .where("YEAR(pickings.date) = ?", @year)
      .includes(picking_documents: :disposal_type).each do |picking|
      picking.picking_documents.each do |picking_document|
        cer_code = picking_document.disposal_type.cer_code
        @summary[cer_code][:kgs] ||= 0.0
        @summary[cer_code][:kgs] += picking_document.kgs
      end
    end

    # remainders is the weight of disposals non delivered in @year
    # FIXME think about picking.date != disposal.delivered_at
    organization.disposals
      .where("YEAR(disposals.approved_at) = ? AND YEAR(disposals.delivered_at) != ?", @year, @year)
      .includes(disposal_type: :cer_code).each do |disposal|
      cer_code = disposal.disposal_type.cer_code
      @remainders[cer_code][:kgs] ||= 0.0
      @remainders[cer_code][:kgs] += disposal.kgs
    end

    # organization.disposals.where("YEAR(disposals.approved_at) = ?", @year).includes(disposal_type: :cer_code).each do |disposal|
    #   cer_code = disposal.disposal_type.cer_code
    #   if disposal.delivered_at && disposal.delivered_at.year == @year
    #     @summary[cer_code][:disposals] ||= []
    #     @summary[cer_code][:disposals] << disposal
    #     @summary[cer_code][:kgs] ||= 0.0
    #     @summary[cer_code][:kgs] += disposal.kgs
    #   elsif disposal.approved?
    #     @remainders[cer_code][:disposals] ||= []
    #     @remainders[cer_code][:disposals] << disposal
    #     @remainders[cer_code][:kgs] ||= 0.0
    #     @remainders[cer_code][:kgs] += disposal.kgs
    #   end
    # end
  end

  def all_cers
    _all ||= (@summary.keys + @remainders.keys).sort.uniq
  end
end
