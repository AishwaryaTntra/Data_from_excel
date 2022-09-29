Rails.application.routes.draw do
  get 'data_imports/new'
  get 'data_imports/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Defines the root path route ("/")
  root 'pages#index'
  resources :data_imports, only: %i[new create]

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
