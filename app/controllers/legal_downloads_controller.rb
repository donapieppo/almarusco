class LegalDownloadsController < LegalRecordsController
  before_action :set_picking_document_and_disposal_type, only: [:new, :create]

  def new
    @legal_download = current_organization.legal_downloads.new(picking_document: @picking_document, disposal_type: @disposal_type, date: Date.today)
    authorize @legal_download
  end

  def create
    @legal_download = current_organization.legal_downloads.new(picking_document: @picking_document,
                                                               disposal_type: @disposal_type, 
                                                               number: params[:legal_download][:number], 
                                                               year: Date.today.year, 
                                                               date: params[:legal_download][:date])
    authorize @legal_download
    if @legal_download.save
      redirect_to root_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def show 
    @legal_download = current_organization.legal_downloads.find(params[:id])
    @picking_document = @legal_download.picking_document
    @picking = @picking_document.picking
    authorize @legal_download
  end

  private

  def set_picking_document_and_disposal_type
    @picking_document = PickingDocument.find(params[:picking_document_id])
    @disposal_type = @picking_document.disposal_type
  end
end
