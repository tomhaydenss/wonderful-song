# frozen_string_literal: true

class MusicalInstrumentsController < ApplicationController
  before_action :set_musical_instrument, only: %i[show edit update destroy]

  # GET /musical_instruments
  # GET /musical_instruments.json
  def index
    @musical_instruments = MusicalInstrument.all.paginate(page: params[:page], per_page: 15)
  end

  # GET /musical_instruments/1
  # GET /musical_instruments/1.json
  def show; end

  # GET /musical_instruments/new
  def new
    @musical_instrument = MusicalInstrument.new
  end

  # GET /musical_instruments/1/edit
  def edit; end

  # POST /musical_instruments
  # POST /musical_instruments.json
  def create
    @musical_instrument = MusicalInstrument.new(musical_instrument_params)

    respond_to do |format|
      if @musical_instrument.save
        format.html { redirect_to @musical_instrument, notice: 'Musical Instrument was successfully created.' }
        format.json { render :show, status: :created, location: @musical_instrument }
      else
        format.html { render :new }
        format.json { render json: @musical_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musical_instruments/1
  # PATCH/PUT /musical_instruments/1.json
  def update
    respond_to do |format|
      if @musical_instrument.update_attributes(musical_instrument_params)
        format.html { redirect_to @musical_instrument, notice: 'Musical Instrument was successfully updated.' }
        format.json { render :show, status: :ok, location: @musical_instrument }
      else
        format.html { render :edit }
        format.json { render json: @musical_instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musical_instruments/1
  # DELETE /musical_instruments/1.json
  def destroy
    @musical_instrument.destroy
    respond_to do |format|
      format.html { redirect_to musical_instruments_url, notice: 'Musical Instrument was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_musical_instrument
    @musical_instrument = MusicalInstrument.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def musical_instrument_params
    params.require(:musical_instrument).permit(:description, :statistic_purpose, :reversible, :block_access)
  end
end
