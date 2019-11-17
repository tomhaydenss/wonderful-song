# frozen_string_literal: true

module AccessAuthorizer
  extend ActiveSupport::Concern

  def self.can_change_member_status?(member, current_user)
    return true if current_user.admin?

    current_user.any_roles?(%i[leader main_leader]) && another_member?(member, current_user)
  end

  def self.another_member?(member, current_user)
    member.id != current_user.member.id
  end

  protected

  def authorization_required_for_resource?
    %w[ensemble_levels identity_document_types memberships phone_types positions ensembles members].include?(params[:controller])
  end

  def fetch_permitted_ensembles_only(include_parent_ensemble = false)
    ensemble = Ensemble.top_level if current_user.any_roles? [:admin]
    ensemble ||= current_user&.member&.highest_ensemble_level_through_leadership
    @permitted_ensembles_only = ensemble.present? ? ensemble.filterable_ensembles(include_parent_ensemble) : []
  end

  def permitted_ensembles_only(members_without_ensemble = false)
    @permitted_ensembles_only ||= fetch_permitted_ensembles_only(true)
    permitted_ensembles_only = { permitted_ensembles_only: @permitted_ensembles_only.map(&:id) }
    permitted_ensembles_only[:permitted_ensembles_only] << nil if members_without_ensemble && current_user.any_roles?(%i[main_leader admin])
    permitted_ensembles_only
  end

  # TODO: should be replaced by authorization feature
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/BlockNesting
  def check_permissions
    return if current_user&.any_roles?([:admin])

    case params[:controller]
    when 'ensemble_levels', 'identity_document_types', 'phone_types', 'positions', 'statuses'
      reject_access
    when 'ensembles'
      reject_access unless current_user.any_roles?(%i[leader main_leader])
      case params[:action]
      when 'new', 'create', 'destroy'
        reject_access unless current_user.any_roles?([:main_leader])
      when 'edit', 'update'
        unless current_user.any_roles?([:main_leader])
          ensemble_id = params[:id].to_i
          reject_access unless can_access_ensemble?(ensemble_id) && another_ensemble?(ensemble_id)
        end
      when 'show'
        unless current_user.any_roles?([:main_leader])
          ensemble_id = params[:id].to_i
          reject_access unless can_access_ensemble?(ensemble_id)
        end
      end
    when 'members'
      case params[:action]
      when 'index', 'new', 'create', 'new_upload', 'upload'
        reject_access unless current_user.any_roles?(%i[leader main_leader])
      when 'destroy', 'new_transfer'
        reject_access unless current_user.any_roles?(%i[leader main_leader]) && another_member?((params[:member_id] || params[:id]).to_i)
      when 'show', 'edit', 'update'
        if another_member?(params[:id].to_i)
          reject_access unless can_access_another_member?(params[:id])
        end
      end
    when 'memberships'
      case params[:action]
      when 'autocomplete'
        reject_access unless current_user.any_roles?(%i[leader main_leader])
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/AbcSize Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/BlockNesting

  def reject_access
    redirect_back fallback_location: (request.referer || root_path), flash: { alert: 'Acesso não autorizado.' }
  end

  def another_member?(member_id)
    member_id != current_user.member.id
  end

  def another_ensemble?(ensemble_id)
    ensemble_id != current_user.member.highest_ensemble_level_through_leadership.id
  end

  def can_access_another_member?(member_id)
    return true if current_user.any_roles?(%i[main_leader admin])

    ensemble_id = Member.find(member_id).ensemble_id
    current_user.any_roles?([:leader]) && can_access_ensemble?(ensemble_id)
  end

  def can_access_ensemble?(ensemble_id)
    permitted_ensembles_only[:permitted_ensembles_only].include?(ensemble_id)
  end
end
