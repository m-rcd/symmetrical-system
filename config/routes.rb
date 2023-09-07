Rails.application.routes.draw do
  get '/round_up' , to: 'round_ups#round_up'
  post '/transfer' , to: 'round_ups#transfer'
  resources :round_ups, only: %i[index new create]
end
