Rails.application.routes.draw do
  # Posts e Comments
  resources :posts do
    resources :comments, only: [ :create ]
  end

  # Autenticação com Devise
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Perfil de Usuários
  resources :users, only: [:show]

  post "/uploads", to: "uploads#process_upload", as: "process_upload"

  # Interface do Sidekiq
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  # Rota Principal
  root "posts#index"

  # Localização
  get "set_locale/:locale", to: "application#set_locale", as: :set_locale
end
