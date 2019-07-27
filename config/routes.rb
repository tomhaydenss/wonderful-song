Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :members
  resources :ensemble_levels
  resources :ensembles
  resources :phone_types
  resources :positions
  resources :identity_document_types
  resources :memberships, only: [:index, :create]

  get '/ongakutai', to: 'home#japan'
  get '/taiyo_ongakutai', to: 'home#brasil'
end
