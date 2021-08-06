class DisposalsController < ApplicationController
  helper DisposalHelper

  before_action :set_disposal_type, only: %i(new create)
  before_action :set_disposal_and_check_permission, only: %i(show edit update destroy approve)

  def index
    if policy(current_organization).manage?
      @disposals = current_organization.disposals
      if params[:u]
        @user = User.find(params[:u].to_i)
        @disposals = @disposals.where(user_id: @user.id)
      end
    else
      @disposals = current_user.disposals
    end
    authorize :disposal
  end

  def show
  end

  def choose_disposal_type
    @disposal_types = current_organization.disposal_types
    authorize :disposal
  end

  def new
    @disposal = current_user.disposals.new(disposal_type_id: @disposal_type.id, 
                                           organization_id: current_organization.id)
    @volumes = {}
    authorize @disposal
  end

  def create
    @disposal = current_user.disposals.new(disposal_params)
    @disposal.organization_id = current_organization.id
    @disposal.disposal_type_id = @disposal_type.id
    authorize @disposal
    if @disposal.save
      fix_volumes
      redirect_to disposals_path
    else
      render action: :new
    end
  end

  def edit
    @volumes = {}
    @disposal.volumes.each do |v|
      @volumes[v.liters.to_i] = v.num.to_i
    end
  end

  def update
    if @disposal.update(disposal_params)
      fix_volumes
      redirect_to disposals_path
    else
      render action: :edit
    end
  end

  def approve
    @disposal.approve!
    redirect_to @disposal
  end

  private

  def disposal_params
    params[:disposal].permit(:kgs, :liters)
  end

  # "solid"=>{"40"=>"1", "60"=>"2", "120"=>""}
  # "liquid"=>{"10"=>"1", "20"=>"2"}
  def fix_volumes
    @disposal.volumes.destroy_all

    h = @disposal.liquid? ? params["liquid"] : params["solid"]
    h.each do |vol, num|
      if num.to_i > 0
        @disposal.volumes.create(liters: vol.to_i, num: num.to_i)
      end
    end
  end

  def set_disposal_type
    @disposal_type = current_organization.disposal_types.find(params[:disposal_type_id])
  end

  def set_disposal_and_check_permission
    @disposal = Disposal.find(params[:id])
    # check organization
    authorize @disposal
  end
end
