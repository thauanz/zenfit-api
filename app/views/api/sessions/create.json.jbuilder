json.(current_user, :id, :name, :email, :role)
json.token JwtWrapper.encode(current_user.as_json)
