# frozen_string_literal: true

class Disposal::CardTitleComponent < ViewComponent::Base
  def initialize(disposal)
    @disposal = disposal
  end
end
