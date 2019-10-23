class MembershipsController < ApplicationController
  include StringUtils

  before_action :valid_file, only: [:create]

  def autocomplete_membership_name
    memberships = Membership.by_id(params[:term]) if searching_by_membership_id?
    memberships ||= Membership.autocomplete(params[:term])
    render json: json_for_autocomplete(memberships, :autocomplete_label, [:name, :email, :birthdate])
  end

  def index
    @membership = Membership.new
    @memberships = Membership.order(:id).all.paginate(page: params[:page], per_page: 15)
  end

  def create
    @membership = Membership.new(membership_params)
    MembershipImportJob.perform_now(@membership)
    redirect_to memberships_path, flash: { success: 'Membership file was successfully uploaded.' }
  end

  private

  def valid_file
    redirect_to memberships_path, flash: { alert: 'Attach a .csv file before upload' } unless params[:membership].present?
  end

  def searching_by_membership_id?
    digits_only(params[:term]).to_i > 0
  end
  
  def membership_params
    params.require(:membership).permit(:csv_file)
  end
end
