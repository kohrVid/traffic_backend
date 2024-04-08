Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'pages#index'
  resources :pages, only: [:index]
  resources :visits, only: [:index, :create]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'devise/passwords',
    confirmations: 'devise/confirmations',
    unlocks: 'devise/unlocks'
  }

  devise_scope :user do
    get 'users/auth', to: 'users/sessions#show'
  end

  resources :users, only: [:show]
end
