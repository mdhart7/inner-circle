Rails.application.routes.draw do
  devise_for :users

  get  "/stylist",         to: "stylist#index"
  post "/stylist/chat",    to: "stylist#chat"
  delete "/stylist/clear", to: "stylist#clear", as: :stylist_clear

  root "pages#index"

  resources :circle_members do
    member do
      patch :accept   
    end
  end

  get "/circle", to: "circles#index", as: "circle"

  resources :posts do
    post :vote, on: :member
  end
end
