Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations' }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  resources :microposts, only: [:create, :destroy, :index]
end
