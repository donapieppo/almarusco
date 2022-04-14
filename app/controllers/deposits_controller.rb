class DepositsController < ApplicationController
  def index
    authorize :deposit
    @deposit = {}
    current_organization.disposals.approved.undelivered.includes(disposal_type: [:cer_code, :un_code, :hp_codes]).each do |disposal|
      @deposit[disposal.disposal_type] ||= []
      @deposit[disposal.disposal_type] << disposal
    end
  end
end
