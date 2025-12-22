# frozen_string_literal: true

class Compliance::ItemComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(compliance, edit: false)
    @compliance = compliance
    @common = compliance.common
    @edit = edit
  end
end
