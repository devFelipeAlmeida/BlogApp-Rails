Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [ :create ]
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :users, only: [:show]

  post "/uploads", to: "uploads#process_upload", as: "process_upload"

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root "posts#index"

  get "set_locale/:locale", to: "application#set_locale", as: :set_locale
end
