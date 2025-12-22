# frozen_string_literal: true

class PermissionAlertComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(permissions)
    @permissions = permissions
  end

  def render?
    @permissions&.any?
  end
end
