# frozen_string_literal: true

class Disposal::CardComponent < ViewComponent::Base
  def initialize(current_user, disposal, with_details: true)
    @current_user = current_user
    @disposal = disposal
    @with_details = with_details

    @policy = DisposalPolicy.new(@current_user, @disposal)
  end
end

