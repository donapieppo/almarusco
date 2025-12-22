# frozen_string_literal: true

class Disposal::CardComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(current_user, disposal, with_details: true, modal: false, highlight: false)
    @current_user = current_user
    @disposal = disposal
    @with_details = with_details
    @highlight = highlight ? "border border-2 border-info" : ""

    @modal = modal

    @policy = DisposalPolicy.new(@current_user, @disposal)
  end
end

