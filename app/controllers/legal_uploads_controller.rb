class LegalUploadsController < LegalRecordsController
  before_action :set_disposal_type, only: [:new, :create]
  before_action :set_disposals, only: [:new, :create]
  before_action :set_legal_upload_and_disposal_type_and_check_permission, only: [:show, :edit, :update]

  def new
    @legal_upload = current_organization.legal_uploads.new(disposal_type: @disposal_type, date: Date.today)
    @registers = current_organization.registers
    authorize @legal_upload
  end

  def create
    @legal_upload = current_organization
      .legal_uploads
      .new(disposal_type: @disposal_type, number: params[:legal_upload][:number], date: params[:legal_upload][:date])
    authorize @legal_upload

    if @legal_upload.save
      @disposals.each do |disposal|
        disposal.legalize!(@legal_upload)
      end
      redirect_to todo_legal_records_path, notice: "I rifiuti sono stati registrati con numero #{@legal_upload.number}."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @legal_upload.update(number: params[:legal_upload][:number], date: params[:legal_upload][:date])
      redirect_to @legal_upload, notice: "Registrazione numero #{@legal_upload.number} aggiornata correttamente."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def show
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

  def set_legal_upload_and_disposal_type_and_check_permission
    @legal_upload = current_organization.legal_uploads.find(params[:id])
    authorize @legal_upload
    @disposal_type = @legal_upload.disposal_type
  end
end
