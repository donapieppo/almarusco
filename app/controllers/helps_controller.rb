class HelpsController < ApplicationController
  def contacts
    skip_authorization
  end
end
