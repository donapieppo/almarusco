# frozen_string_literal: true

class DisposalType::CardComponent < ViewComponent::Base
  def initialize(current_user, disposal_type, editable: true, with_details: true, with_links: true)
    @current_user = current_user
    @disposal_type = disposal_type
    @with_details = with_details
    @with_links = with_links

    @editable = editable
    @policy = DisposalTypePolicy.new(@current_user, @disposal_type)
  end
end
