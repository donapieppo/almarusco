class UnCodesController < ApplicationController
  before_action :set_un_code_and_check_permission, only: [:edit, :update, :destroy]

  def index
    authorize :un_code
    @un_codes = UnCode.order(:id).all
  end

  def new
    @un_code = UnCode.new
    authorize @un_code
  end

  # FIXME bad choiche id from user?
  def create
    _id = params[:un_code][:id].to_i
    if _id > 0
      if UnCode.find_by_id(_id)
        skip_authorization
        redirect_to un_codes_path, alert: "Codice già esistente."
      else
        @un_code = UnCode.new(un_code_params)
        authorize @un_code
        if @un_code.save
          redirect_to un_codes_path, notice: "Codice UN creato correttamente."
        else
          render action: :new, status: :unprocessable_entity
        end
      end
    else
      @un_code = UnCode.new(un_code_params)
      authorize @un_code
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @un_code.update(un_code_params)
      redirect_to un_codes_path, notice: "Il nome del laboratorio è stato modificato."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_un_code_and_check_permission
    @un_code = UnCode.find(params[:id])
    authorize @un_code
  end

  def un_code_params
    params[:un_code].permit(:id, :name)
  end
end
