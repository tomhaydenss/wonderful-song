Rails.application.routes.draw do
  resources :members
  resources :ensemble_levels
  root to: 'home#index'
end
