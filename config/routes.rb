Rails.application.routes.draw do
  # Posts e Comments
  resources :posts do
    resources :comments, only: [ :create ]
  end

  # Autenticação com Devise
  devise_for :users

  # Perfil de Usuários
  resources :users, only: [ :show ]

  # Rota de Saúde
  get "up" => "rails/health#show", as: :rails_health_check

  # Progressive Web App (PWA)
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "/uploads", to: "uploads#process_upload"

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
