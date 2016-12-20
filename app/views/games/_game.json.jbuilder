json.extract! game, :id, :player_red_id, :player_blue_id, :games_state, :red_turn, :created_at, :updated_at, :won
json.url game_url(game, format: :json)