Rails.application.routes.draw do
  resources :members
  root to: 'home#index'
end
