class MembershipsController < ApplicationController
  before_action :valid_file, only: [:create]

  autocomplete :membership, :name, full: true, extra_data: [:email, :birthdate]

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
  
  def membership_params
    params.require(:membership).permit(:csv_file)
  end
end
