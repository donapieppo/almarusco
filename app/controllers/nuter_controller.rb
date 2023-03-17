class NuterController < ApplicationController
  def charts
    authorize :nuter
    @labels = (1..12).map { |month| Date::MONTHNAMES[month] }
    @disposals = (1..Date.today.month).map { |month| Disposal.where("created_at >= ? and created_at <= ?", "2023/#{month}/01", "2023/#{month}/31").approved.count }

    @uls = Disposal.includes(:organization).group(:organization_id).count
  end

  def report
    authorize :nuter
    if params[:supplier_id]
      @month = params[:month].to_i
      year = (Date.today.month < @month) ? Date.today.year - 1 : Date.today.year
      date_from = "#{year}-#{@month}-01"
      date_to = "#{year}-#{@month}-31"
      @supplier = Supplier.find(params[:supplier_id])
      @pickings = @supplier.pickings
        .where("date >= ? and date <= ?", date_from, date_to)
        .where("completed_at is not null")
        .includes(:organization, picking_documents: [disposal_type: :cer_code])
        .order(:organization_id)
    else
      @pickings = []
    end
  end
end
