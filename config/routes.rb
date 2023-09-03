Rails.application.routes.draw do
  get 'round_ups/index'
  get 'round_ups/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "round_ups#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
