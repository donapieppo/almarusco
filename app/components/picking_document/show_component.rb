# frozen_string_literal: true

class PickingDocument::ShowComponent < ViewComponent::Base
  def initialize(current_user, picking, disposal_type, expected_kgs: nil, expected_liters: nil)
    @current_user = current_user
    @picking = picking
    @disposal_type = disposal_type

    @picking_document = @picking.picking_documents.where(disposal_type: @disposal_type).first   
  end
end


