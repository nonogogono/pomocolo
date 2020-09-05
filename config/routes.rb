Rails.application.routes.draw do
  root 'static_pages#home'
  get '/timer', to: 'static_pages#timer'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: "users/confirmations",
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end
  resources :microposts, only: [:create, :destroy]
  resources :tasks, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
