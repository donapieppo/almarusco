# frozen_string_literal: true

class Disposal::BadgeComponent < ViewComponent::Base
  def initialize(current_user, disposal, small: false)
    @current_user = current_user
    @disposal = disposal
    @small = small

    @badge_color = @disposal.legalized? ? 'bg-info' : 'bg-warning text-dark'
  end
end


