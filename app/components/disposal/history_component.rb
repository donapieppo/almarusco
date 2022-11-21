# frozen_string_literal: true

class Disposal::HistoryComponent < ViewComponent::Base
  def initialize(disposal)
    @disposal = disposal
  end
end
