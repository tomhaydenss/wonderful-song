# frozen_string_literal: true

class MembershipsController < ApplicationController
  include StringUtils

  before_action :valid_file, only: [:create]

  def autocomplete_membership_name
    memberships = Membership.by_id(params[:term]) if searching_by_membership_id?
    memberships ||= Membership.autocomplete(params[:term])
    render json: json_for_autocomplete(memberships, :autocomplete_label, %i[name email birthdate])
  end

  def index
    @membership = Membership.new
    @memberships = Membership.order(:id).all.paginate(page: params[:page], per_page: 15)
  end

  def create
    @membership = Membership.new(membership_params)
    MembershipImportJob.perform_now(@membership)
    redirect_to memberships_path, flash: { success: 'Arquivo de Membros Associados enviado com sucesso.' }
  end

  private

  def valid_file
    redirect_to memberships_path, flash: { alert: 'Selecione um arquivo .csv antes de importar.' } unless params[:membership].present?
  end

  def searching_by_membership_id?
    digits_only(params[:term]).to_i.positive?
  end

  def membership_params
    params.require(:membership).permit(:csv_file)
  end
end
