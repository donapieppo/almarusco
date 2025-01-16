class PickingRequest
  attr_reader :volumes_and_kgs

  def initialize(picking)
    @picking = picking

    @volumes_and_kgs = Hash.new { |hash, key| hash[key] = {} }
    set_disposal_types_volumes_and_kgs
  end

  def set_disposal_types_volumes_and_kgs
    @picking.disposals.include_all.each do |disposal|
      dt = disposal.disposal_type
      @volumes_and_kgs[dt][:volumes] ||= {}
      @volumes_and_kgs[dt][:kgs] ||= 0.0

      @volumes_and_kgs[dt][:volumes][disposal.volume.to_s] = @volumes_and_kgs[dt][:volumes][disposal.volume.to_s].to_i + disposal.units
      @volumes_and_kgs[dt][:kgs] = @volumes_and_kgs[dt][:kgs] + disposal.kgs
    end

    # complete with possibities for this picking supplier
    @picking.supplier.contract_disposal_types(@picking.organization_id).each do |dt|
      @volumes_and_kgs[dt][:kgs] ||= 0
      @volumes_and_kgs[dt][:volumes] ||= {}
      @volumes_and_kgs[dt][:volumes]["10"] ||= 0
      @volumes_and_kgs[dt][:volumes]["20"] ||= 0
      @volumes_and_kgs[dt][:volumes]["40"] ||= 0
      @volumes_and_kgs[dt][:volumes]["60"] ||= 0
    end
  end

  def volumes_and_kgs_ordered
    res = []
    @volumes_and_kgs.each do |dt, h|
      res << {name: dt.cer_code.name, dt: dt, values: h}
    end
    res.sort_by { |x| x[:name] }
  end
end
