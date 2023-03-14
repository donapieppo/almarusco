# frozen_string_literal: true

class PickingDocument::DisposalsCardComponent < ViewComponent::Base
  def initialize(current_user, picking_document, disposals: nil)
    @current_user = current_user
    @picking_document = picking_document
    @disposals = disposals || @picking_document.disposals
  end
end
