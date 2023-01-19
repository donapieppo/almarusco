# frozen_string_literal: true

class LegalDownload::LineComponent < ViewComponent::Base
  def initialize(legal_download)
    @legal_download = legal_download
  end
end
