# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(user)
    edit_member_path(user.member.id)
  end
end
