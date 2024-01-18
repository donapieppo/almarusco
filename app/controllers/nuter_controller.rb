class NuterController < ApplicationController
  def charts
    authorize :nuter
    @labels = (1..12).map { |month| Date::MONTHNAMES[month] }
    @disposals = (1..12).map do |month|
      Disposal.where("approved_at >= ? and approved_at <= ?", "2023/#{month}/01", "2023/#{month}/31").count
    end

    @uls = Disposal.where("approved_at >= ? and approved_at <= ?", "2023/01/01", "2023/12/31").includes(:organization).group(:organization_id).count

    @cer_codes = Disposal.where("approved_at >= ? and approved_at <= ?", "2023/01/01", "2023/12/31").joins(:disposal_type).group(:cer_code_id).count

    @cer_code_prices = Disposal.where("approved_at >= ? and approved_at <= ?", "2023/01/01", "2023/12/31").joins(:disposal_type).group(:cer_code_id).sum(:kgs)
    @prices = {}
    @cer_code_prices.each do |cer_code_id, number|
      contract = Contract.where(cer_code_id: cer_code_id).first
      @prices[cer_code_id] = number * (contract ? contract.price : 0)
    end
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
