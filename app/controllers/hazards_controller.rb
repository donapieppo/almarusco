class HazardsController < ApplicationController
  def index
    authorize :hazard
    @hazards = Hazard.order(:category, :code)
  end
end
