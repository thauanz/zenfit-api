json.extract! user, :id, :name, :email
json.url api_user_url(user, format: :json)