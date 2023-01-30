class LoginsController < ApplicationController
  skip_before_action :check_current_organization

  def no_access
    skip_authorization
  end
end
