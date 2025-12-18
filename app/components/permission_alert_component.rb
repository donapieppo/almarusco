# frozen_string_literal: true

class PermissionAlertComponent < ViewComponent::Base
  include DmUniboCommon::IconHelper

  def initialize(permissions)
    @permissions = permissions
  end

  def render?
    @permissions&.any?
  end
end
