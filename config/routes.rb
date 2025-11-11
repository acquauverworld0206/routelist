Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :spots do
    collection do
      post :random_draw
    end
  end
  resources :groups do
    collection do
      post :random_draw
    end
    resources :invitations, only: [:create] # ネストされた作成アクション
    resources :messages, only: [:create]
    resources :candidate_spots, only: [:create, :destroy]
    member do
      post :random_draw
    end
  end

  resources :candidate_spots, only: [] do
    resources :votes, only: [:create, :destroy]
  end

  # 招待の一覧、承認、拒否のためのルート
  resources :invitations, only: [:index] do
    member do
      patch :accept
      patch :reject
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
