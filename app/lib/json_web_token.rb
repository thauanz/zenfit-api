class JsonWebToken < Devise::Strategies::Base
  def valid?
    request.headers['Authorization'].present?
  end

  def authenticate!
    return fail! unless claims
    return fail! unless claims.key?('id')

    success! User.find_by_id claims['id']
  end

  protected

  def claims
    strategy, token = request.headers['Authorization'].split(' ')
    return nil if (strategy || '').downcase != 'bearer'
    JwtWrapper.decode(token) rescue nil
  end
end
