class HelpsController < ApplicationController
  def index
  end

  def contacts
    skip_authorization
  end
end
