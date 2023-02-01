# frozen_string_literal: true

class Disposal::StatusComponent < ViewComponent::Base
  def initialize(current_user, disposal, no_link: false)
    @current_user = current_user
    @disposal = disposal
    @no_link = no_link

    @status = @disposal.status
    @status_icon = disposal.approved? ? '<i class="fas fa-check text-success"></i>' : '<i class="fas fa-exclamation-circle text-danger"></i>'

    @policy = DisposalPolicy.new(@current_user, @disposal)
  end
end
