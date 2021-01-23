Rails
  .application
  .routes
  .draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root to: 'home#index'

    resources :ajudameuvoto, only: [:index]
    resources :states, only: [:show]
    resources :politicians, only: [:show, :index]
    resources :parties, only: [:show]

    namespace :api, defaults: { format: :json } do
      scope :v1 do
        resources :search, only: [:index]
        resources :help_me_answers, only: [:create]
      end
    end
  end
