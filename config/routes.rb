Rails.application.routes.draw do
  get 'data_imports/new'
  get 'data_imports/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Defines the root path route ("/")
  root 'cities#index'
  # post 'locations/new', to: 'locations#new', as: 'new_location'
  resources :data_imports, only: %i[new create]

  resources :cities do
    resources :locations
  end
  resources :locations do
    resources :users
    resources :messages
  end
  # resources :locations do
    
  # end

  # resources :cities do |city|
  #   city.resources :locations, name_prefix: 'city_'
  # end

  # resources :locations do |locations|
  #   locations.resources :users, name_prefix: 'location_'
  #   locations.resources :messages, name_prefix: 'location_'
  # end
end
