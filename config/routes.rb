Rails.application.routes.draw do
  root 'static_pages#home'
  get '/timer', to: 'static_pages#timer'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  resources :users, only: [:show]
  resources :microposts, only: [:create, :destroy]
end
