class DepositsController < ApplicationController
  def index
    authorize :deposit
    @at = params[:at]
    @deposit = {}
    @approved_at = []
    current_organization.disposals.approved.undelivered.includes(disposal_type: [:cer_code, :un_code, :hp_codes]).each do |disposal|
      if (! @at) || @at == disposal.approved_at.to_s
        @deposit[disposal.disposal_type] ||= []
        @deposit[disposal.disposal_type] << disposal
      end
      @approved_at << disposal.approved_at
    end
    @approved_at = @approved_at.sort.uniq
  end
end
