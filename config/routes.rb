Rails.application.routes.draw do
  devise_for :users

  root "pages#index"

  get "/up", to: "health#show", as: :rails_health_check
  get "/manifest.json", to: "rails/pwa#manifest", as: :pwa_manifest
  get "/service-worker.js", to: "rails/pwa#service_worker", as: :pwa_service_worker

  get    "/stylist",         to: "stylist#index"
  post   "/stylist/chat",    to: "stylist#chat"
  delete "/stylist/clear",   to: "stylist#clear", as: :stylist_clear

  post "/posts/:id/vote", to: "posts#vote", as: :vote_post

  get "/circle", to: "circles#index", as: :circle

  resources :circle_members, only: [ :create, :destroy ] do
    member do
      patch :accept
    end
  end

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
  end
end
