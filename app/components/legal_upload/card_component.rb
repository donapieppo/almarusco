# frozen_string_literal: true

class LegalUpload::CardComponent < ViewComponent::Base
  def initialize(current_user, legal_upload)
    @legal_upload = legal_upload
    @current_user = current_user
    @disposals = @legal_upload.disposals
  end
end
