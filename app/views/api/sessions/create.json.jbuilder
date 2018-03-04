json.(current_user, :id, :name, :email)
json.token JwtWrapper.encode(current_user.as_json)
