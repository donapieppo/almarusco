# frozen_string_literal: true

class Picking::LineComponent < ViewComponent::Base
  def initialize(picking)
    @picking = picking
    @bg = if @picking.completed?
      "list-group-item-secondary text-secondary"
    elsif @picking.delivered?
      "list-group-item-info"
    else
      "list-group-item-success"
    end
  end
end
