# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  get '/ongakutai', to: 'home#japan'
  get '/taiyo_ongakutai', to: 'home#brasil'
  get '/precepts', to: 'home#precepts'
  get 'my_info', to: 'home#my_info'

  get 'members/autocomplete_member_name', to: 'members#autocomplete_member_name'
  get 'ensembles/autocomplete_ensemble_name', to: 'ensembles#autocomplete_ensemble_name'
  get 'memberships/autocomplete_membership_name', to: 'memberships#autocomplete_membership_name'

  get 'members/upload/new', to: 'members#new_upload'
  post 'members/upload', to: 'members#upload'

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :members do
    resources :transfers, only: [:new], to: 'members#new_transfer'
  end
  resources :ensemble_levels
  resources :ensembles
  resources :phone_types
  resources :positions
  resources :statuses
  resources :musical_instruments
  resources :identity_document_types
  resources :memberships, only: %i[index create]
end
