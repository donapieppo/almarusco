# frozen_string_literal: true

class PickingDocument::ShowComponent < ViewComponent::Base
  def initialize(current_user, picking, disposal_type, expected_kgs: nil, expected_volume: nil)
    @current_user = current_user
    @picking = picking
    @disposal_type = disposal_type
    @expected_kgs = expected_kgs
    @expected_volume = expected_volume

    @picking_document = @picking.picking_documents.where(disposal_type: @disposal_type).first   

    @all_ok = (@picking_document && @picking_document.kgs.to_i == @expected_kgs.round && @picking_document.volume == @expected_volume)
  end
end


