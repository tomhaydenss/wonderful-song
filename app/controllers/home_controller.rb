# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def brasil; end

  def japan; end

  def precepts; end

  def my_info
    redirect_to current_user.member
  end
end
