require 'rails_helper'

RSpec.shared_examples_for 'requesting users as' do
  shared_examples_for 'invalid authentication' do
    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'GET /api/users' do
    context 'with authentication' do
      before do
        get '/api/users', headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:ok) }
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

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response[:id]).to eq(user.id) }
      it { expect(json_response[:name]).to eq(user.name) }
      it { expect(json_response[:email]).to eq(user.email) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get "/api/users/#{user.id}"
      end
    end
  end

  context 'POST /api/users' do
    let(:user_attributes) { attributes_for(:user, :manager) }

    context 'with authentication' do
      before do
        post '/api/users',
          params: { user: user_attributes },
          headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:created) }

      it 'assigns the requested user' do
        expect(assigns(:user)).not_to be_nil
      end

      it { expect(json_response[:name]).to eq(user_attributes[:name]) }
      it { expect(json_response[:email]).to eq(user_attributes[:email]) }
    end

    context 'does not insert user' do
      before do
        post '/api/users',
          params: { user: { email: '' } },
          headers: auth_header(login_user)
      end

      it { expect(json_response[:errors]).not_to be_blank }
    end

    it 'does insert new user' do
      expect do
        post '/api/users',
          params: { user: user_attributes },
          headers: auth_header(login_user)
      end.to change(User, :count).from(1).to(2)
    end

    it_behaves_like 'invalid authentication' do
      before do
        post '/api/users', params: { user: attributes_for(:user) }
      end
    end
  end

  context 'PUT /api/users/:id' do
    let(:user) { create(:user, :manager) }

    context 'with authentication' do
      before do
        put "/api/users/#{user.id}",
          params: { user: { name: 'Wolverine' } },
          headers: auth_header(login_user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response[:name]).to eq('Wolverine') }
    end

    context 'invalid parameters' do
      before do
        put "/api/users/#{user.id}",
          params: { user: { name: '' } },
          headers: auth_header(login_user)
      end

      it { expect(json_response[:errors]).not_to be_blank }
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

      it { expect(response).to have_http_status(:ok) }
    end

    it 'does remove user' do
      expect { delete "/api/users/#{user.id}", headers: auth_header(login_user) }.to \
        change(User, :count).from(2).to(1)
    end

    it_behaves_like 'invalid authentication' do
      before do
        delete "/api/users/#{user.id}"
      end
    end
  end
end

RSpec.describe 'when the user login as a role admin', type: :request do
  it_behaves_like 'requesting users as' do
    let!(:login_user) { create(:user, :admin) }
  end
end

RSpec.describe 'when the user login as a role manager', type: :request do
  it_behaves_like 'requesting users as' do
    let!(:login_user) { create(:user, :manager) }
  end
end
