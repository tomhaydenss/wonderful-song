class PhoneTypesController < ApplicationController
  before_action :set_phone_type, only: [:show, :edit, :update, :destroy]

  # GET /phone_types
  # GET /phone_types.json
  def index
    @phone_types = PhoneType.order(:id).all
  end

  # GET /phone_types/1
  # GET /phone_types/1.json
  def show
  end

  # GET /phone_types/new
  def new
    @phone_type = PhoneType.new
  end

  # GET /phone_types/1/edit
  def edit
  end

  # POST /phone_types
  # POST /phone_types.json
  def create
    @phone_type = PhoneType.new(phone_type_params)

    respond_to do |format|
      if @phone_type.save
        format.html { redirect_to @phone_type, notice: 'Phone Type was successfully created.' }
        format.json { render :show, status: :created, location: @phone_type }
      else
        format.html { render :new }
        format.json { render json: @phone_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phone_types/1
  # PATCH/PUT /phone_types/1.json
  def update
    respond_to do |format|
      if @phone_type.update_attributes(phone_type_params)
        format.html { redirect_to @phone_type, notice: 'Phone Type was successfully updated.' }
        format.json { render :show, status: :ok, location: @phone_type }
      else
        format.html { render :edit }
        format.json { render json: @phone_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_types/1
  # DELETE /phone_types/1.json
  def destroy
    @phone_type.destroy
    respond_to do |format|
      format.html { redirect_to phone_types_url, notice: 'Phone Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone_type
      @phone_type = PhoneType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_type_params
      params.require(:phone_type).permit(:description)
    end
end
