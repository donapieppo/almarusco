class HazardsController < ApplicationController
  def index
    authorize :hazard
    @hazards = Hazard.order(:code)
  end
end
