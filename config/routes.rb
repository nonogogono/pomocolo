Rails.application.routes.draw do
  root 'static_pages#home'
  get '/timer', to: 'static_pages#timer'
  get '/week', to: 'static_pages#week'
  get '/month', to: 'static_pages#month'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: "users/confirmations",
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  resources :users, only: :show do
    member do
      get :following, :followers
    end
  end
  resources :microposts, only: [:create, :destroy, :show] do
    resources :comments, only: [:create, :destroy]
  end
  resources :tasks, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :notifications, only: :index
end
