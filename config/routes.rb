Rails.application.routes.draw do
  devise_for :users

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
