# frozen_string_literal: true

class PickingDocument::ShowComponent < ViewComponent::Base
  def initialize(current_user, picking, disposal_type, expected_kgs: nil, expected_volume: nil)
    @current_user = current_user
    @picking = picking
    @disposal_type = disposal_type
    @expected_kgs = expected_kgs
    @expected_volume = expected_volume

    @picking_document = @picking.picking_documents.where(disposal_type: @disposal_type).first   

    if @picking_document && @picking_document.kgs == @expected_kgs && @picking_document.volume == @expected_volume
      @all_ok = true
    else
      @all_ok = false
    end
  end
end


