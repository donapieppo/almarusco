# Modello Unico di Dichiarazione Ambientale
class Mud
  attr_reader :organization, :summary, :remainders

  # @summary[cer][:disposals] = [d1, d2...]
  # @summary[cer][:kgs] = 123
  def initialize(organization, year: 2022)
    @organization = organization
    @year = year
    @summary = Hash.new { |hash, key| hash[key] = {} }
    @remainders = Hash.new { |hash, key| hash[key] = {} }
    organization.disposals.includes(disposal_type: :cer_code).each do |disposal|
      cer_code = disposal.disposal_type.cer_code
      if disposal.delivered?
        @summary[cer_code][:disposals] ||= []
        @summary[cer_code][:disposals] << disposal
        @summary[cer_code][:kgs] ||= 0.0
        @summary[cer_code][:kgs] += disposal.kgs
      elsif disposal.approved?
        @remainders[cer_code][:disposals] ||= []
        @remainders[cer_code][:disposals] << disposal
        @remainders[cer_code][:kgs] ||= 0.0
        @remainders[cer_code][:kgs] += disposal.kgs
      end
    end
  end

  def all_cers
    _all ||= (@summary.keys + @remainders.keys).sort.uniq
  end
end

