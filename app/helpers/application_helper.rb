include DmUniboCommonHelper

module ApplicationHelper
  def disposal_status_icon(disposal)
    if disposal.approved?
      '<i class="fas fa-check text-success"></i>'.html_safe
    else
      '<i class="fas fa-exclamation-circle text-danger"></i>'.html_safe
    end
  end
end
