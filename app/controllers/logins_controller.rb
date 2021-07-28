class LoginsController < ApplicationController
  def no_access
    authorize :login
  end
end
