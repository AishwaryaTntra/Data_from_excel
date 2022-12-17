# frozen_string_literal: true

Rails.application.routes.draw do
  get 'data_import_csvs/data_generate'
  post 'city/:id/city_customer_message', to: 'cities#city_customers_message', as: 'city_customer_message'
  get 'city/:id/new_city_customer_message', to: 'cities#new_city_customer_message', as: 'new_city_customer_message'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Defines the root path route ("/")
  root 'pages#index'
  resources :data_import_csvs, only: %i[new create]

  devise_for :users, controllers: {
    sessions: 'devise/sessions',
    registrations: 'devise/registrations'
  }

  resources :cities do
    resources :locations
  end
  resources :locations do
    resources :customers
    resources :messages
  end
end
