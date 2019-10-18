class ApplicationController < ActionController::Base
  include AccessAuthorizer

  before_action :authenticate_user!, if: :authorization_required_for_resource?
  before_action :check_permissions
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:membership_id, :birthdate])
  end
end
