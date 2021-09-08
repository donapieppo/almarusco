class InfosController < ApplicationController
  def index
    authorize :info
    @infos = {}
    current_organization.disposals.each do |disposal|
      @infos[disposal.disposal_type] ||= []
      @infos[disposal.disposal_type] << disposal
    end
  end
end
