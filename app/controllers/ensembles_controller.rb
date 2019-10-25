# frozen_string_literal: true

class EnsemblesController < ApplicationController
  before_action -> { fetch_permitted_ensembles_only(true) }, only: %i[index new]
  before_action :set_ensemble, only: %i[show edit update destroy]

  # GET /ensembles
  # GET /ensembles.json
  def index
    filters = params.merge(permitted_ensembles_only).slice(:permitted_ensembles_only)
    @ensembles = Ensemble.filter(filters)
                         .order('id, foundation_date')
                         .includes(:ensemble_parent)
                         .paginate(page: params[:page], per_page: 15)
  end

  # GET /ensembles/1
  # GET /ensembles/1.json
  def show; end

  # GET /ensembles/new
  def new
    @ensemble = Ensemble.new
  end

  # GET /ensembles/1/edit
  def edit; end

  # POST /ensembles
  # POST /ensembles.json
  def create
    @ensemble = Ensemble.new(ensemble_params)

    respond_to do |format|
      if @ensemble.save
        format.html { redirect_to @ensemble, notice: 'Ensemble was successfully created.' }
        format.json { render :show, status: :created, location: @ensemble }
      else
        format.html { render :new }
        format.json { render json: @ensemble.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ensembles/1
  # PATCH/PUT /ensembles/1.json
  def update
    respond_to do |format|
      if @ensemble.update_attributes(ensemble_params)
        format.html { redirect_to @ensemble, notice: 'Ensemble was successfully updated.' }
        format.json { render :show, status: :ok, location: @ensemble }
      else
        format.html { render :edit }
        format.json { render json: @ensemble.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ensembles/1
  # DELETE /ensembles/1.json
  def destroy
    @ensemble.destroy
    respond_to do |format|
      format.html { redirect_to ensembles_url, notice: 'Ensemble was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ensemble
    @ensemble = Ensemble.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ensemble_params
    params.require(:ensemble).permit(
      :name, :foundation_date, :history, :ensemble_level_id, :ensemble_parent_id, :leadership_purpose,
      leaders_attributes: [:id, :member_id, :appointment_date, :primary, :_destroy,
                           leader_roles_attributes: %i[id position_id additional_information primary _destroy]]
    )
  end
end
