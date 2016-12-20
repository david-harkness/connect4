json.extract! user, :id, :name, :wins, :losses, :created_at, :updated_at
json.url user_url(user, format: :json)