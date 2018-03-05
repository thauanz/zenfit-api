require 'rails_helper'

RSpec.describe 'when the user login has the role of Regular', type: :request do
  let!(:login_user) { create(:user, :regular) }

  shared_examples_for 'invalid authentication' do
    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'GET /api/users' do
    context 'with authentication' do
      before do
        get '/api/users', headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get '/api/users'
      end
    end
  end

  context 'GET /api/users/:id' do
    let(:user) { create(:user, :manager) }

    context 'with authentication' do
      before do
        get "/api/users/#{user.id}", headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get "/api/users/#{user.id}"
      end
    end
  end

  context 'POST /api/users' do
    let(:user_attributes) { attributes_for(:user, :regular) }

    context 'with authentication' do
      before do
        post '/api/users',
          params: { user: user_attributes },
          headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it 'does not insert new user' do
      expect do
        post '/api/users',
          params: { user: user_attributes },
          headers: auth_header(login_user)
      end.not_to change(User, :count)
    end

    it_behaves_like 'invalid authentication' do
      before do
        post '/api/users', params: { user: attributes_for(:user) }
      end
    end
  end

  context 'PUT /api/users/:id' do
    let(:user) { create(:user, :regular) }

    context 'with authentication' do
      before do
        put "/api/users/#{user.id}",
          params: { user: { name: 'Wolverine' } },
          headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        put "/api/users/#{user.id}",
          params: { user: { name: 'Logan' } }
      end
    end
  end

  context 'DELETE /api/users/:id' do
    let!(:user) { create(:user, :manager) }

    context 'with authentication' do
      before do
        delete "/api/users/#{user.id}",
          headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it 'does not remove user' do
      expect do
        delete "/api/users/#{user.id}", headers: auth_header(login_user)
      end.not_to change(User, :count)
    end

    it_behaves_like 'invalid authentication' do
      before do
        delete "/api/users/#{user.id}"
      end
    end
  end
end
