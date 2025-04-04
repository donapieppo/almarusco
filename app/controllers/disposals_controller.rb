class DisposalsController < ApplicationController
  helper DisposalHelper

  before_action :set_disposal_type, only: %i[new create]
  before_action :set_permitted_producers, only: %i[new create edit update clone]
  before_action :set_cache_users, only: %i[new clone edit]
  before_action :set_disposal_and_check_permission, only: %i[show edit update destroy approve unapprove]

  # solo rifiuti prima della registrazione
  def index
    authorize :disposal
    @highlight_id = params[:h].to_i

    @disposals = current_organization.disposals.unlegalized.order("disposals.id DESC, disposals.user_id ASC").include_all

    if policy(current_organization).manage?
      if params[:u]
        @user = User.find(params[:u].to_i)
        @disposals = @disposals.user_or_producer(@user.id)
      end
      if params[:uncomplete]
        @title = "Richieste incomplete"
        @disposals = @disposals.uncomplete
      elsif params[:acceptable]
        @title = "Richieste da accettare"
        @disposals = @disposals.complete.unapproved
      else
        @title = "Rifiuti non registrati"
      end
    else
      @title = "Elenco rifiuti"
      @disposals = @disposals.user_or_producer(current_user.id)
    end

    disposal_type_ids = @disposals.map(&:disposal_type_id).uniq
    @disposals_cers = current_organization.disposal_types.includes(:cer_code).where(id: disposal_type_ids).map(&:cer_code).uniq
  end

  def show
    @modal = params[:modal]
    render layout: false if modal_page
  end

  def choose_disposal_type
    @hidden = policy(current_organization).manage? ? params[:hidden].to_i : 0
    @disposal_types = current_organization.disposal_types.where(hidden: params[:hidden].to_i).with_all_includes.order("cer_codes.name")
    authorize :disposal
  end

  def new
    @disposal = current_user.disposals.new(
      disposal_type_id: @disposal_type.id,
      organization_id: current_organization.id
    )
    authorize @disposal
  end

  def clone
    @orig = Disposal.find(params[:id])
    @disposal_type = @orig.disposal_type
    @disposal = current_user.disposals.new(
      disposal_type_id: @disposal_type.id,
      organization_id: current_organization.id,
      lab_id: @orig.lab_id,
      volume: @orig.volume,
      producer_id: @orig.producer_id
    )
    authorize @disposal
    render action: :new
  end

  def create
    @disposal = current_user.disposals.new
    @disposal.organization_id = current_organization.id
    @disposal.disposal_type_id = @disposal_type.id

    set_producer
    @disposal.assign_attributes(disposal_params)

    authorize @disposal

    if @disposal.producer_id && @disposal.save
      Rails.logger.info("Disposal #{@disposal.inspect} created by #{current_user.upn}")
      redirect_to disposals_path(h: @disposal.id, anchor: @disposal.id), notice: "Salvata la richiesta di scarico con identificativo #{@disposal.id}. Consigliamo di scrivere il numero identificativo sul collo."
    else
      # Rails.logger.info(@disposal.errors.inspect)
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    set_producer

    if @disposal.producer_id && @disposal.update(disposal_params)
      redirect_to @disposal
      # redirect_to disposals_path(h: @disposal.id, anchor: @disposal.id)
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def approve
    respond_to do |format|
      _res = @disposal.approve!
      format.html { redirect_to @disposal }
      format.turbo_stream
    end
  end

  def unapprove
    respond_to do |format|
      _res = @disposal.unapprove!
      format.html { redirect_to @disposal }
      format.turbo_stream
    end
  end

  def destroy
    @disposal.destroy
    redirect_to disposals_path
  end

  def search
    authorize :disposal
    # Remember: can be more than number (example disposals with many units)
    requested_disposal_id = params[:search_string].to_i
    # TODO
    # @disposal = current_organization.disposals.find_by_local_id(requested_disposal_id)
    @disposal = current_organization.disposals.find_by_id(requested_disposal_id)
    if @disposal && !policy(current_organization).manage? && @disposal.user_id != current_user.id && @disposal.producer_id != current_user.id
      @disposal = nil
    end

    if @disposal
      redirect_to @disposal
    else
      redirect_to disposals_path(__org__: current_organization.code), notice: "In questa UL non è registato nessun rifiuto con identificativo #{requested_disposal_id}."
    end
  end

  def archive
    authorize :disposal
    @year = 2021
    @disposals = current_organization.disposals
      .include_all
      .delivered
      .where("YEAR(disposals.delivered_at) = ?", @year)
    @disposal_types = current_organization.disposal_types.where(id: @disposals.map(&:disposal_type_id).sort.uniq)
  end

  private

  # no producer or user!
  def disposal_params
    params[:disposal].permit(:kgs, :units, :container_id, :lab_id, :notes, :multiple_users)
  end

  def set_disposal_type
    @disposal_type = current_organization.disposal_types.find(params[:disposal_type_id])
    unless policy(current_organization).manage?
      @disposal_type.hidden and raise "No permission on hidden type"
    end
  end

  def set_disposal_and_check_permission
    @disposal = current_organization.disposals.find(params[:id])
    authorize @disposal
  end

  # if user is operator can also be producer for themself
  def set_permitted_producers
    @permitted_producers = current_user.permitted_producers(current_organization)
    if @permitted_producers.any? && current_user.authorization.can_dispose?(current_organization)
      @permitted_producers << current_user
    end
  end

  def set_cache_users
    @cache_users_json = current_organization.users_cache.map { |x| "#{x.to_s} (#{x.upn})" }.to_json
  end

  # Operator chooses from a select. User already in db.
  def set_producer_by_operator(producer_id)
    if @permitted_producers.any?
      producer = User.find(producer_id)
      unless producer && @permitted_producers.include?(producer)
        raise "PRODUCER ERRATO"
      end
      @disposal.producer_id = producer.id
    end
  end

  def set_producer_by_admin(producer_upn)
    if producer_upn =~ /(\w+\.\w+)/ && policy(current_organization).manage?
      begin
        producer = User.find_or_syncronize("#{$1}@unibo.it")
        @disposal.producer_id = producer.id
      rescue => e
        Rails.logger.info "Error: #{e.to_s} while validating producer=#{$1}@unibo.it"
        @disposal.errors.add(:producer_upn, :invalid, message: e.to_s)
        @disposal.errors.add(:base, :invalid, message: e.to_s)
        return false
      end
    end
  end

  # if @permitted_producers => current_user only operator and @permitted_producers array that must contain producer_id
  # else is producer itsself
  # if errors fills disposal.errors and leave producer_id = nil
  def set_producer
    producer_id = params[:disposal].delete(:producer_id)
    producer_upn = params[:disposal].delete(:producer_upn)

    if producer_id.to_i > 0
      set_producer_by_operator(producer_id)
    elsif !producer_upn.blank?
      set_producer_by_admin(producer_upn)
    else
      @disposal.producer_id = current_user.id
    end
  end
end
