Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :members
  resources :ensemble_levels
  resources :ensembles
  resources :phone_types
  resources :positions
end
