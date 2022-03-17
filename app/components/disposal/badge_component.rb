# frozen_string_literal: true

class Disposal::BadgeComponent < ViewComponent::Base
  def initialize(current_user, disposal)
    @current_user = current_user
    @disposal = disposal
  end
end


