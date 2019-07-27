class IdentityDocumentTypesController < ApplicationController
  before_action :set_identity_document_type, only: [:show, :edit, :update, :destroy]

  # GET /identity_document_types
  # GET /identity_document_types.json
  def index
    @identity_document_types = IdentityDocumentType.order(:id).all
  end

  # GET /identity_document_types/1
  # GET /identity_document_types/1.json
  def show
  end

  # GET /identity_document_types/new
  def new
    @identity_document_type = IdentityDocumentType.new
  end

  # GET /identity_document_types/1/edit
  def edit
  end

  # POST /identity_document_types
  # POST /identity_document_types.json
  def create
    @identity_document_type = IdentityDocumentType.new(identity_document_type_params)

    respond_to do |format|
      if @identity_document_type.save
        format.html { redirect_to @identity_document_type, notice: 'Identity Document Type was successfully created.' }
        format.json { render :show, status: :created, location: @identity_document_type }
      else
        format.html { render :new }
        format.json { render json: @identity_document_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /identity_document_types/1
  # PATCH/PUT /identity_document_types/1.json
  def update
    respond_to do |format|
      if @identity_document_type.update_attributes(identity_document_type_params)
        format.html { redirect_to @identity_document_type, notice: 'Identity Document Type was successfully updated.' }
        format.json { render :show, status: :ok, location: @identity_document_type }
      else
        format.html { render :edit }
        format.json { render json: @identity_document_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identity_document_types/1
  # DELETE /identity_document_types/1.json
  def destroy
    @identity_document_type.destroy
    respond_to do |format|
      format.html { redirect_to identity_document_types_url, notice: 'Identity Document Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identity_document_type
      @identity_document_type = IdentityDocumentType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_document_type_params
      params.require(:identity_document_type).permit(:description)
    end
end
