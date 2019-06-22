class ApplicationController < ActionController::Base
  before_action :authenticate_user! unless Rails.env.development?
end
