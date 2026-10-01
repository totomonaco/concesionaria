ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "test_drive", "test_drives"
end

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "admin/vehicles#index"
  get "/admin", to: "admin/vehicles#index"

  resources :test_drives, only: %i[new create show]
  resources :appraisals, only: %i[new create show]

  namespace :api do
    namespace :v1 do
      post   "sessions",      to: "sessions#create"
      delete "sessions",      to: "sessions#destroy"
      post   "registrations", to: "registrations#create"
      resources :vehicles,    only: %i[index show]
      resources :test_drives, only: %i[index create]
      resources :appraisals,  only: %i[index create]
      get    "profile",     to: "profile#show"
    end
  end

  namespace :admin do
    root "vehicles#index"
    get "login",  to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :vehicles do
      member do
        delete :purge_photo
      end
    end
    resources :brands
    resources :vehicle_models
    resources :test_drives, only: %i[index show update destroy] do
      member do
        patch :confirm
        patch :cancel
      end
    end
    resources :sales, only: %i[index new create show destroy]
    resources :appraisals, only: %i[index show update]
  end
end
