# frozen_string_literal: true

class Disposal::StatusComponent < ViewComponent::Base
  def initialize(current_user, disposal, modal: false)
    @current_user = current_user
    @disposal = disposal
    @modal = modal

    @policy = DisposalPolicy.new(@current_user, @disposal)

    @status = @disposal.status
    @status_icon = disposal.approved? ? '<i class="fas fa-check text-success"></i>' : '<i class="fas fa-exclamation-circle text-danger"></i>'
  end
end
