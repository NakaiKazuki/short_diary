Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  resources :microposts, only: [:create, :destroy]
end
