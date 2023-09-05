Rails.application.routes.draw do
  get 'round_ups/index'
  get 'round_ups/new'
  post 'round_ups/create' , to: 'round_ups#create'
  resources :round_ups, only: %i[index new create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "round_ups#index"
end
