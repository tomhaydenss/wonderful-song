Rails.application.routes.draw do
  root to: 'home#index'
  get '/ongakutai', to: 'home#japan'
  get '/taiyo_ongakutai', to: 'home#brasil'

  get 'members/autocomplete_member_name', to: 'members#autocomplete_member_name'
  get 'memberships/autocomplete_membership_name', to: 'memberships#autocomplete_membership_name'

  get 'members/upload/new', to: 'members#new_upload'
  post 'members/upload', to: 'members#upload'

  devise_for :users
  resources :members
  resources :ensemble_levels
  resources :ensembles
  resources :phone_types
  resources :positions
  resources :identity_document_types
  resources :memberships, only: [:index, :create]

end