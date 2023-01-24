# frozen_string_literal: true

class LegalDownload::CardComponent < ViewComponent::Base
  def initialize(current_user, legal_download)
    @legal_download = legal_download
    @current_user = current_user

    @picking_document = @legal_download.picking_document
    @picking = @picking_document.picking

    @policy = LegalDownloadPolicy.new(@current_user, @legal_download)
  end
end
