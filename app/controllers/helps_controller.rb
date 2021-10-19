class HelpsController < ApplicationController
  def index 
    skip_authorization
  end

  def contacts
    skip_authorization
  end
end
