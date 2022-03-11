# frozen_string_literal: true

class DisposalType::CardComponent < ViewComponent::Base
  def initialize(current_user, disposal_type, editable: true, with_details: true)
    @current_user = current_user
    @disposal_type = disposal_type
    @with_details = with_details

    @editable = editable && DisposalTypePolicy.new(@current_user, @disposal_type).edit?
  end
end

