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
                                                               date: params[:legal_download][:date])
    authorize @legal_download
    if @legal_download.save
      redirect_to @legal_download.picking_document.picking, notice: "Registrazione scarico effettuata con numero #{@legal_download.number}"
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def show 
  end

  def edit
    @disposal_type = @legal_download.disposal_type
  end

  def update
    if @legal_download.update(number: params[:legal_download][:number],
                              date: params[:legal_download][:date])
      redirect_to @legal_download.picking_document.picking, notice: "Registrazione scarico effettuata con numero #{@legal_download.number}"
    else
      @disposal_type = @legal_download.disposal_type
      render action: :edit, status: :unprocessable_entity
    end
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
