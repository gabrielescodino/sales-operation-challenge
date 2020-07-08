require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  Rails.application.routes.draw do
    root to: 'sessions#new'

    mount Sidekiq::Web => '/sidekiq'

    resources :sales_reports, only: %i[create index show]

    match '/auth/:provider/callback' => 'sessions#create',  as: :auth_callback, via: :get
    match '/auth/failure'            => 'sessions#failure', as: :auth_failure, via: :get
    match '/logout'                  => 'sessions#destroy', as: :logout, via: :get
    match '/login'                   => 'sessions#new',     as: :login, via: :get
  end
end
