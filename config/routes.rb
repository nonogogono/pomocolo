Rails.application.routes.draw do
  root 'static_pages#home'
  get '/timer', to: 'static_pages#timer'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show]
end
