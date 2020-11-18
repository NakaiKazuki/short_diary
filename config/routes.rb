Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'users/confirmations' }
  root "static_pages#home"
end
