class LegalUploadsController < LegalRecordsController
  before_action :set_disposal_type, only: [:new, :create]
  before_action :set_disposals, only: [:new, :create]

  def new
    @legal_upload = current_organization.legal_uploads.new(disposal_type: @disposal_type, date: Date.today)
    authorize @legal_upload
  end

  def create
    @legal_upload = current_organization.legal_uploads.new(disposal_type: @disposal_type, 
                                                           number: params[:legal_upload][:number], 
                                                           year: Date.today.year, 
                                                           date: params[:legal_upload][:date])
    authorize @legal_upload
    if @legal_upload.save
      @disposals.each do |disposal|
        disposal.legalize!(@legal_upload)
      end
      redirect_to todo_legal_records_path
    else
      set_disposals_and_picking_document
      render action: :new, status: :unprocessable_entity
    end
  end

  def show 
    @legal_upload = current_organization.legal_uploads.find(params[:id])
    @disposals = @legal_upload.disposals
    authorize @legal_upload
  end

  private

  def set_disposal_type
    @disposal_type = DisposalType.find(params[:disposal_type_id])
  end

  def set_disposals
    @disposal_ids = params[:disposal_ids] 

    if @disposal_ids.any?
      @disposals = Disposal.find(@disposal_ids)
    end
  end
end
