require 'rails_helper'

RSpec.describe 'Login', type: :request do
  let(:user) { create(:user) }

  context 'does return the information to authenticate' do
    before do
      post '/api/login.json', params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response[:email]).to eq(user.email) }
    it { expect(json_response[:token]).not_to be_blank }
    it { expect(json_response[:name]).to eq(user.name) }
  end

  context 'does not permit login' do
    before do
      post '/api/login.json', params: {
        user: {
          email: 'invalid'
        }
      }
    end

    it { expect(response).to have_http_status(:unauthorized) }
  end
end
