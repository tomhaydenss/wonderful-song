# frozen_string_literal: true

class StatisticsController < ApplicationController
  before_action :fetch_permitted_ensembles_only, only: %i[index ensemble]

  def index
    @ensemble_statistics = false
  end

  def ensemble
    @ensemble_parent = Ensemble.find(params[:ensemble_parent]) if params[:ensemble_parent].present?
    @ensemble_statistics = true
    render 'index'
  end
end
