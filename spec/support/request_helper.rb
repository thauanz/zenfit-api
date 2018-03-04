module Request
  module JsonHelper
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module AuthenticateHelper
    def auth_header(user)
      {
        'Authorization' => "Bearer #{JwtWrapper.encode(user.as_json)}"
      }
    end
  end
end
