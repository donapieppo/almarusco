# frozen_string_literal: true

class Disposal::ShowComponent < ViewComponent::Base
  def initialize(current_user, disposal, with_details: true)
    @current_user = current_user
    @disposal = disposal
    @with_details = with_details

    @status_icon = disposal.approved? ? '<i class="fas fa-check text-success"></i>' : '<i class="fas fa-exclamation-circle text-danger"></i>'
    @policy = DisposalPolicy.new(current_user, disposal)
  end
end

