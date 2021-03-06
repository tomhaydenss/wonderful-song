# frozen_string_literal: true

class PositionsController < ApplicationController
  before_action :set_position, only: %i[show edit update destroy]

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.order(:precedence_order).all.paginate(page: params[:page], per_page: 15)
  end

  # GET /positions/1
  # GET /positions/1.json
  def show; end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit; end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(position_params)

    respond_to do |format|
      if @position.save
        format.html { redirect_to @position, notice: 'Função criada com sucesso.' }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update_attributes(position_params)
        format.html { redirect_to @position, notice: 'Função atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url, notice: 'Função excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_position
    @position = Position.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def position_params
    params.require(:position).permit(:description, :precedence_order)
  end
end
