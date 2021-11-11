class InfosController < ApplicationController
  def index
    authorize :info
    @infos = {}
    current_organization.disposals.undelivered.includes(disposal_type: [:cer_code, :un_code, :hp_codes]).each do |disposal|
      @infos[disposal.disposal_type] ||= []
      @infos[disposal.disposal_type] << disposal
    end
  end
end
