class MudController < ApplicationController
  def show
    authorize :mud
    @mud = Mud.new(current_organization, year: 2022)
    @summary = @mud.summary
    @remainders = @mud.remainders
  end
end

