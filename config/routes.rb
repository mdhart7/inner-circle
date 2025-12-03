Rails.application.routes.draw do
  root "pages#index"

  devise_for :users

  resource :circle, controller: "circles", only: [:index]

  resources :circle_members do
    member do
      patch :accept
    end
  end

  resources :posts do
    post :vote, on: :member
  end
end
