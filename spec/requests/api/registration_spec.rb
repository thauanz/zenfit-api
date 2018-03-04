require 'rails_helper'

RSpec.describe 'Register user', type: :request do
  let(:user_attributes) { attributes_for(:user) }

  context 'does return the information to authenticate' do
    before do
      post '/api/register.json', params: { user: user_attributes }
    end

    it { expect(response).to have_http_status(:created) }
    it { expect(json_response[:email]).to eq(user_attributes[:email]) }
    it { expect(json_response[:name]).to eq(user_attributes[:name]) }
  end

  context 'does not register invalid user' do
    before do
      post '/api/register.json', params: {
        user: {
          email: 'invalid'
        }
      }
    end

    it { expect(response).to have_http_status(:unprocessable_entity) }
    it { expect(json_response[:errors]).not_to be_blank }
  end
end
