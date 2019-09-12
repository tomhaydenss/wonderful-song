class MembersController < ApplicationController
  before_action :set_available_ensembles, only: [:index, :new]
  before_action :set_member, only: [:show, :edit, :update, :destroy, :new_transfer]
  before_action :new_member, only: [:new, :new_upload]

  autocomplete :member, :name, full: true

  # GET /members
  # GET /members.json
  def index
    filters = params.slice(:ensemble_id, :search)
    @members = Member.filter(filters).order(:name).all.paginate(page: params[:page], per_page: 15)
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new; end

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
        set_available_ensembles
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

  def new_upload; end

  def upload
    @member = Member.new(member_params)
    MemberImportJob.perform_now(@member)
    redirect_to members_path, flash: { success: 'Member file was successfully uploaded.' }
  end

  def new_transfer; end

  private
    def set_available_ensembles
      # TODO waiting for authorization impl
      # @filterable_ensembles = current_user.member.highest_ensemble_level_through_leadership.filterable_ensembles
      @available_ensembles = Ensemble.joins(:ensemble_level).where('ensemble_levels.precedence_order = ?', 0).first.filterable_ensembles # admin only
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id] || params[:member_id])
    end

    def new_member
      @member = Member.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(
        :name, :email, :ensemble_id, :joining_date, :birthdate, :food_restrictions, :additional_information, :membership_id, :csv_file,
        phones_attributes: [:id, :phone_number, :phone_type_id, :additional_information, :primary, :_destroy],
        addresses_attributes: [:id, :postal_code, :street, :number, :additional_information, :neighborhood, :city, :state, :primary, :_destroy],
        identity_documents_attributes: [:id, :number, :complement, :identity_document_type_id, :_destroy]
      )
    end
end
