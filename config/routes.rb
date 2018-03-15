Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :zentimes
    resources :users
    get 'report' => 'reports#index'
  end

  devise_for :users,
    format: :json,
    path: '/api',
    skip: [:confirmations],
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'register'
    },
    controllers: { sessions: 'api/sessions' }
end
