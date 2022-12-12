# frozen_string_literal: true

class DisposalType::PictogramsComponent < ViewComponent::Base
  def initialize(disposal_type, size: 100)
    @disposal_type = disposal_type
    @size = size
  end
end
