require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'sign_in_with_otp', to: 'users/sessions#sign_in_with_otp'
    get 'resend_otp', to: 'users/sessions#resend_otp'
    post 'validate_otp', to: 'users/sessions#validate_otp'
  end

  mount CmAdmin::Engine => '/cm_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'cm_admin/static#index'

  get :health_check, to: 'application#health_check'

  resources :pdfs, only: [] do
    get :result_pdf
    get :result_pdf_spanish
  end

  resources :whatsapp, only: [] do
    collection do
      post :flow
      get 'webhook', to: 'whatsapp#get_webhook'
      post 'webhook', to: 'whatsapp#post_webhook'
    end
  end
end
