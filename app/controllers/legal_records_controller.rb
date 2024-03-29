class LegalRecordsController < ApplicationController
  def index
    authorize :legal_record
    @legal_records = current_organization.legal_records.includes(disposal_type: :cer_code).order("year desc, number desc")
    @disposal_types = @legal_records.map { |lr| lr.disposal_type }.uniq
  end

  def todo
    authorize :legal_record
    @deposit = {}
    current_organization.disposals.approved.unlegalized.includes(disposal_type: [:cer_code, :un_code, :hp_codes]).each do |disposal|
      @deposit[disposal.disposal_type] ||= []
      @deposit[disposal.disposal_type] << disposal
    end
  end
end
