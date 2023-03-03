class ReportsController < ApplicationController
  def index
    authorize :report
    if params[:supplier_id]
      @month = params[:month].to_i
      year = (Date.today.month < @month) ? Date.today.year - 1 : Date.today.year
      date_from = "#{year}-#{@month}-01"
      date_to = "#{year}-#{@month}-31"
      @supplier = Supplier.find(params[:supplier_id])
      @pickings = @supplier.pickings
        .where("date >= ? and date <= ?", date_from, date_to)
        .where('completed_at is not null')
        .includes(:organization, picking_documents: [disposal_type: :cer_code])
        .order(:organization_id)
    else
      @pickings = []
    end
  end
end
