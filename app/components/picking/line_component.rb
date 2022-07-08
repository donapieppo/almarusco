# frozen_string_literal: true

class Picking::LineComponent < ViewComponent::Base
  def initialize(picking)
    @picking = picking
    if @picking.completed_at
      @bg = 'list-group-item-secondary'
    elsif @picking.delivered_at 
      @bg = 'list-group-item-info'
    else
      @bg = 'list-group-item-success'
    end
  end
end



