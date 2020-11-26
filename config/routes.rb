Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  root "static_pages#home"
  resources :microposts, only: [:create, :destroy]
end
