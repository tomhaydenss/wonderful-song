Rails.application.routes.draw do
  devise_for :users
  resources :members
  resources :ensemble_levels
  root to: 'home#index'
end
