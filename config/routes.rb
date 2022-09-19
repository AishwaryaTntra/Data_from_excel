Rails.application.routes.draw do
  get 'data_imports/new'
  get 'data_imports/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Defines the root path route ("/")
  root 'cities#index'
  resources :data_imports, only: %i[new create]

  resources :cities do
    resources :locations
  end
  resources :locations do
    resources :users
    resources :messages
  end
end
