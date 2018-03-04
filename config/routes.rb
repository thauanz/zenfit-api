Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users,
      path: '/',
      skip: [:confirmations],
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'register'
      },
      controllers: { sessions: 'api/sessions' }
  end
end
