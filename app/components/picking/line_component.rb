# frozen_string_literal: true

class Picking::LineComponent < ViewComponent::Base
  def initialize(picking)
    @picking = picking
  end

  def background
    if @picking.completed?
      "list-group-item-dark"
    elsif @picking.delivered?
      "list-group-item-warning"
    else
      "list-group-item-success"
    end
  end
end
