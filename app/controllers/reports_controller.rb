class ReportsController < ApplicationController
  def index
    authorize :report
    if params[:supplier_id]
      @supplier = Supplier.find(params[:supplier_id])
      @pickings = @supplier.pickings.where("date > DATE_SUB(NOW(), INTERVAL 3 MONTH)")
                                    .where('completed_at is not null')
                                    .includes(:organization, picking_documents: [disposal_type: :cer_code])
                                    .order(:organization_id)
    else
      @pickings = []
    end
  end
end
