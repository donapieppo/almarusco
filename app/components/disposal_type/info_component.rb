# frozen_string_literal: true

class DisposalType::InfoComponent < ViewComponent::Base
  def initialize(disposal_type)
    @disposal_type = disposal_type
  end
end
