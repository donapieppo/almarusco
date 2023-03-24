# frozen_string_literal: true

class PickingDocument::ShowComponent < ViewComponent::Base
  def initialize(current_user, picking_document, disposals: nil)
    @current_user = current_user
    @picking_document = picking_document
    @picking = @picking_document.picking
    @disposal_type = @picking_document.disposal_type
    # just a cache usually
    @disposals = disposals || @picking.disposals.where(disposal_type: @disposal_type)

    @expected_kgs = 0.0
    @expected_volume = 0

    disposals.each do |disposal|
      (@expected_kgs += disposal.kgs) if disposal.kgs
      (@expected_volume += disposal.volume_tot) if disposal.volume
    end

    @all_ok = @picking_document && @picking_document.kgs && @picking_document.volume &&
      (@picking_document.kgs - @expected_kgs).abs < 1 &&
      @picking_document.volume == @expected_volume

    @picking_document_policy = PickingDocumentPolicy.new(@current_user, @picking_document)
  end
end
