class MudController < ApplicationController
  def show
    authorize :mud
    @year = 2023
    @mud = Mud.new(current_organization, year: @year)
    @summary = @mud.summary
    @remainders = @mud.remainders
  end
end
