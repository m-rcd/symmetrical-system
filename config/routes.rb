Rails.application.routes.draw do
  post '/round_up' , to: 'round_ups#round_up'
  post '/transfer' , to: 'round_ups#transfer'
  resources :round_ups, only: %i[index new create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root "round_ups#index"
end
