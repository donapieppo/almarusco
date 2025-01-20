class MudController < ApplicationController
  def show
    authorize :mud
    @year = 2024
    @mud = Mud.new(current_organization, @year)
    @picked_kgs = @mud.picked_kgs
    @remainders_kgs = @mud.remainders_kgs
  end
end
