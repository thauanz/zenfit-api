json.extract! user, :id, :name, :email, :role
json.url api_user_url(user, format: :json)
