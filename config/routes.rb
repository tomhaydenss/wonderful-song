Rails.application.routes.draw do
  devise_for :users
  resources :members
  resources :ensemble_levels
  resources :ensembles
  root to: 'home#index'
end
