class InfosController < ApplicationController
  def index
    authorize :info
  end
end
