# frozen_string_literal: true

class Compliance::ItemComponent < ViewComponent::Base
  def initialize(compliance, edit: false)
    @compliance = compliance
    @common = compliance.common
    @edit = edit
  end
end
