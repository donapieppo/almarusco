class MudController < ApplicationController
  def show
    authorize :mud
    @year = params[:y] ? params[:y].to_i : 2024
    @mud = Mud.new(current_organization, @year)
    @picked_kgs = @mud.picked_kgs
    @remainders_kgs = @mud.remainders_kgs
  end
end
