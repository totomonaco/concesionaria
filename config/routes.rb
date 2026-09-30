ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "test_drive", "test_drives"
end

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :test_drives, only: %i[new create show]

  namespace :api do
    namespace :v1 do
      post   "sessions",    to: "sessions#create"
      delete "sessions",    to: "sessions#destroy"
      resources :vehicles,    only: %i[index show]
      resources :test_drives, only: %i[index create]
      get    "profile",     to: "profile#show"
    end
  end

  namespace :admin do
    root "vehicles#index"
    get "login",  to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :vehicles
    resources :brands
    resources :vehicle_models
    resources :test_drives do
      member do
        patch :confirm
        patch :cancel
      end
    end
    resources :sales, only: %i[index new create show destroy]
  end
end
