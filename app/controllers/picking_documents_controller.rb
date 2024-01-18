class PickingDocumentsController < ApplicationController
  before_action :set_picking_and_check_permission, only: [:new, :create]
  before_action :set_picking_document_and_check_permission, only: [:show, :edit, :update]

  def new
    if !@picking.date
      redirect_to [:edit, @picking], alert: "Manca la data del ritiro"
    else
      @picking_document = @picking.picking_documents.new
      @picking_document.disposal_type_id = params[:disposal_type_id]
    end
  end

  def create
    @picking_document = @picking.picking_documents.new(picking_document_params)
    if @picking_document.save
      redirect_to @picking, notice: "Il documento è stato salvato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def show
    @legal_download = @picking_document.legal_download
  end

  def edit
  end

  def update
    if @picking_document.update(picking_document_params)
      redirect_to @picking, notice: "Il documento è stato aggiornato correttamente."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def set_picking_and_check_permission
    @picking = current_organization.pickings.find(params[:picking_id])
    # FIXME
    authorize @picking, :edit?
  end

  def set_picking_document_and_check_permission
    @picking_document = PickingDocument.find(params[:id])
    @picking = @picking_document.picking
    authorize @picking_document
  end

  def picking_document_params
    params[:picking_document].permit(:disposal_type_id, :serial_number, :kgs, :volume)
  end
end
