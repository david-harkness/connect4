Rails.application.routes.draw do
  root 'play#index'
  get 'play/index'

  resources :games
  resources :users
  scope '/api' do
    scope '/v1' do
      scope '/games' do
        post '/add_token' => "games#add_token"
        get '/game_state/:id' => 'games#show'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
