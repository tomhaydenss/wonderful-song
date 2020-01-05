# frozen_string_literal: true

class MembersController < ApplicationController
  include MembersToCsv
  include StringUtils

  before_action :fetch_permitted_ensembles_only, only: %i[index new]
  before_action :set_member, only: %i[show edit update destroy new_transfer]
  before_action :new_member, only: %i[new new_upload]
  before_action :build_member, only: %i[create upload]
  before_action :apply_filter, only: [:index]
  before_action :valid_file, only: [:upload]

  def autocomplete_member_name
    members = Member.by_membership_id(params[:term]) if searching_by_membership_id?
    members ||= Member.autocomplete(params[:term])
    render json: json_for_autocomplete(members, :name)
  end

  # GET /members
  # GET /members.json
  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @members, status: :ok, location: @member }
      format.csv { send_data to_csv(@members), filename: "members-#{DateTime.now.strftime('%Y%m%d%H%M%S')}.csv" }
    end
  end

  def apply_filter
    @members = Member.filter(filters).order(:name)
    @members = if %w[json csv].include? params['format']
                 @members.includes(:ensemble, :addresses, phones: [:phone_type], identity_documents: [:identity_document_type])
               else
                 @members.includes(:ensemble).paginate(page: params[:page], per_page: 15)
               end
  end

  # GET /members/1
  # GET /members/1.json
  def show; end

  # GET /members/new
  def new; end

  # GET /members/1/edit
  def edit; end

  # POST /members
  # POST /members.json
  def create
    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        fetch_permitted_ensembles_only
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
        format.html { redirect_to updated_path, notice: 'Member was successfully updated.' }
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
    MemberImportJob.perform_now(@member)
    redirect_to members_path, flash: { success: 'Member file was successfully uploaded.' }
  end

  def new_transfer; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id] || params[:member_id])
  end

  def new_member
    @member = Member.new
  end

  def build_member
    @member = Member.new(member_params)
  end

  def valid_file
    redirect_to members_upload_new_path, flash: { alert: 'Attach a .csv file before upload' } unless params[:member].present?
  end

  def filters
    params.merge(permitted_ensembles_only(true)).slice(:permitted_ensembles_only, :ensemble_id, :search)
  end

  def searching_by_membership_id?
    digits_only(params[:term]).to_i.positive?
  end

  def updated_path
    request.params['commit'] == 'Salvar' ? @member : members_path
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(
      :name, :email, :ensemble_id, :joining_date, :birthdate, :food_restrictions, :additional_information,
      :membership_id, :status_id,
      :csv_file,
      phones_attributes: %i[id phone_number phone_type_id additional_information primary _destroy],
      addresses_attributes: %i[id postal_code street number additional_information neighborhood city state primary _destroy],
      identity_documents_attributes: %i[id number complement identity_document_type_id _destroy],
      member_musical_instruments_attributes: %i[id musical_instrument_id primary _destroy]
    )
  end
end
