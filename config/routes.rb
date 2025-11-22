Rails.application.routes.draw do
  root "pages#index"

  devise_for :users


  get "/circle", to: "circles#index"

  get    "/stylist",         to: "stylist#index"
  post   "/stylist/chat",    to: "stylist#chat",  as: :stylist_chat
  delete "/stylist/clear",   to: "stylist#clear", as: :stylist_clear

  resources :circle_members, only: [:create, :destroy]

  resources :posts do
    post :vote, on: :member
  end
end
