# frozen_string_literal: true

class Disposal::AcceptComponent < ViewComponent::Base
  def initialize(current_user, disposal)
    @current_user = current_user
    @disposal = disposal
  end

  # FIXME with DisposalPolicy#approve? unapprove?
  def render?
    (! @disposal.assigned) && OrganizationPolicy.new(@current_user, @disposal.organization).manage?
  end
end


