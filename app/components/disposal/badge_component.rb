# frozen_string_literal: true

class Disposal::BadgeComponent < ViewComponent::Base
  def initialize(current_user, disposal, linked: false)
    @current_user = current_user
    @disposal = disposal
    @linked = linked
  end
end


