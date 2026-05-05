class MudController < ApplicationController
  def show
    authorize :mud
    @year = params[:y] ? params[:y].to_i : 2025
    @mud = Mud.new(current_organization, @year)
    @picked_kgs = @mud.picked_kgs
    @remainders_kgs = @mud.remainders_kgs
    @remainders = @mud.remainders
  end
end
