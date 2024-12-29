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

  # Rota Principal
  root "posts#index"
end
