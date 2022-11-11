class PickingRequest
  attr_reader :disposal_types_volumes_and_kgs

  def initialize(picking)
    @picking = picking

    @disposal_types_volumes_and_kgs = @picking.disposal_types_volumes_and_kgs
    add_all_possible_disposal_types
  end

  def add_all_possible_disposal_types
    @picking.supplier.contract_disposal_types(@picking.organization_id).each do |dt|
      @disposal_types_volumes_and_kgs[dt][:kgs] ||= 0
      @disposal_types_volumes_and_kgs[dt][:volumes] ||= {}
      @disposal_types_volumes_and_kgs[dt][:volumes]["10"] ||= 0
      @disposal_types_volumes_and_kgs[dt][:volumes]["20"] ||= 0
      @disposal_types_volumes_and_kgs[dt][:volumes]["40"] ||= 0
      @disposal_types_volumes_and_kgs[dt][:volumes]["60"] ||= 0
    end
  end
end
