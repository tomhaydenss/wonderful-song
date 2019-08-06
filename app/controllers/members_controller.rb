class MembersController < ApplicationController
  before_action :set_filterable_ensembles, only: [:index]
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  # GET /members.json
  def index
    filters = params.slice(:ensemble_id)
    @members = Member.filter(filters).order(:name).all
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update_attributes(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_filterable_ensembles
      # TODO waiting for athorization impl
      # @filterable_ensembles = current_user.member.highest_ensemble_level_through_leadership.filterable_ensembles
      @filterable_ensembles = Ensemble.joins(:ensemble_level).where('ensemble_levels.precedence_order = ?', 0).first.filterable_ensembles # admin only
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(
        :name, :email, :ensemble_id, :joining_date, :birthdate, :food_restrictions, :additional_information,
        phones_attributes: [:id, :phone_number, :phone_type_id, :additional_information, :primary, :_destroy],
        emails_attributes: [:id, :email_address, :primary, :_destroy],
        addresses_attributes: [:id, :postal_code, :street, :number, :additional_information, :neighborhood, :city, :state, :primary, :_destroy],
        identity_documents_attributes: [:id, :number, :complement, :identity_document_type_id, :_destroy]
      )
    end
end
