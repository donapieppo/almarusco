class LegalDownloadsController < LegalRecordsController
  before_action :set_picking_document_and_disposal_type, only: [:new, :create]
  before_action :set_legal_download_and_check_permission, only: [:show, :edit, :update, :delete]

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
      redirect_to @legal_download, notice: "Registrazione scarico effettuata con numero #{@legal_download.number}"
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def show 
    @picking_document = @legal_download.picking_document
    @picking = @picking_document.picking
  end

  def edit
    @disposal_type = @legal_download.disposal_type
  end

  private

  def set_picking_document_and_disposal_type
    @picking_document = PickingDocument.find(params[:picking_document_id])
    @disposal_type = @picking_document.disposal_type
  end

  def set_legal_download_and_check_permission
    @legal_download = current_organization.legal_downloads.find(params[:id])
    authorize @legal_download
  end
end
