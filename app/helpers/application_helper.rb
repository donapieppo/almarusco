include DmUniboCommonHelper

module ApplicationHelper
  def disposal_status_icon(disposal)
    if disposal.approved?
      '<i class="fas fa-check text-success"></i>'.html_safe
    else
      '<i class="fas fa-exclamation-circle text-danger"></i>'.html_safe
    end
  end

  def policy_authlevel_color(p)
    case p.authlevel
    when 20
      'text-secondary'
    when 40
      'text-warning'
    when 60
      'text-danger'
    end
  end
end
