# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController

  def update
    user = User.with_reset_password_token(params['user']['reset_password_token'])
    User.reset_password_by_token({
      reset_password_token: params['user']['reset_password_token'],
      password: params['user']['password'],
      password_confirmation: params['user']['password_confirmation']
    })
    redirect_to new_user_session_path, notice: 'Sua senha foi redefinida com sucesso.'
  end
end
