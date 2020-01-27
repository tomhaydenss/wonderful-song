# frozen_string_literal: true

class EnsembleLevelsController < ApplicationController
  before_action :set_ensemble_level, only: %i[show edit update destroy]

  # GET /ensemble_levels
  # GET /ensemble_levels.json
  def index
    @ensemble_levels = EnsembleLevel.order(:precedence_order).all.paginate(page: params[:page], per_page: 15)
  end

  # GET /ensemble_levels/1
  # GET /ensemble_levels/1.json
  def show; end

  # GET /ensemble_levels/new
  def new
    @ensemble_level = EnsembleLevel.new
  end

  # GET /ensemble_levels/1/edit
  def edit; end

  # POST /ensemble_levels
  # POST /ensemble_levels.json
  def create
    @ensemble_level = EnsembleLevel.new(ensemble_level_params)

    respond_to do |format|
      if @ensemble_level.save
        format.html { redirect_to @ensemble_level, notice: 'Nível de Núcleo criado com sucesso.' }
        format.json { render :show, status: :created, location: @ensemble_level }
      else
        format.html { render :new }
        format.json { render json: @ensemble_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ensemble_levels/1
  # PATCH/PUT /ensemble_levels/1.json
  def update
    respond_to do |format|
      if @ensemble_level.update_attributes(ensemble_level_params)
        format.html { redirect_to @ensemble_level, notice: 'Nível de Núcleo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @ensemble_level }
      else
        format.html { render :edit }
        format.json { render json: @ensemble_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ensemble_levels/1
  # DELETE /ensemble_levels/1.json
  def destroy
    @ensemble_level.destroy
    respond_to do |format|
      format.html { redirect_to ensemble_levels_url, notice: 'Nível de Núcleo excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ensemble_level
    @ensemble_level = EnsembleLevel.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ensemble_level_params
    params.require(:ensemble_level).permit(:description, :precedence_order)
  end
end
