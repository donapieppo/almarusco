# frozen_string_literal: true

class Compliance::ItemComponent < ViewComponent::Base
  def initialize(compliance, edit: false)
    @compliance = compliance
    @edit = edit
  end
end
